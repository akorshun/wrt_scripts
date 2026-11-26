#!/bin/sh
set -eu

REPO="anothaDev/luci-theme-vantage"
API_URL="https://api.github.com/repos/${REPO}/releases/latest"

# --- Environment checks ---
if ! command -v apk >/dev/null 2>&1; then
    echo "Error: 'apk' not found. This script requires OpenWrt 25.12+." >&2
    exit 1
fi

if command -v curl >/dev/null 2>&1; then
    fetch_text() { curl -fsSL "$1"; }
    download_file() { curl -fsSL -o "$2" "$1"; }
elif command -v wget >/dev/null 2>&1; then
    fetch_text() { wget -qO- "$1"; }
    download_file() { wget -qO "$2" "$1"; }
else
    echo "Error: neither 'curl' nor 'wget' was found." >&2
    exit 1
fi

TMPDIR="$(mktemp -d /tmp/vantage-install.XXXXXX)"
trap 'rm -rf "$TMPDIR"' EXIT INT TERM

PKG_DIR="$TMPDIR/pkgs"
URLS_FILE="$TMPDIR/urls.txt"
LANGS_FILE="$TMPDIR/langs.txt"
mkdir -p "$PKG_DIR"

# --- Fetch .apk list from the latest GitHub release ---
echo "Fetching latest release info for ${REPO}..."
RELEASE_JSON="$(fetch_text "$API_URL")"

VERSION="$(printf '%s\n' "$RELEASE_JSON" \
    | tr ',' '\n' \
    | sed -n 's/.*"tag_name"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' \
    | head -n 1)"

printf '%s\n' "$RELEASE_JSON" \
    | tr ',' '\n' \
    | sed -n 's/.*"browser_download_url"[[:space:]]*:[[:space:]]*"\([^"]*\.apk\)".*/\1/p' \
    > "$URLS_FILE"

if [ ! -s "$URLS_FILE" ]; then
    echo "Error: no .apk files found in the latest release (${VERSION:-unknown})." >&2
    exit 1
fi

echo "Found release: ${VERSION:-latest}"

# Extract package name without version from .apk URL
pkg_name_from_url() {
    file="${1##*/}"
    printf '%s\n' "$file" | sed 's/[-_][0-9].*\.apk$//'
}

# Extract language code from an i18n package name
lang_from_pkg() {
    case "$1" in
        luci-i18n-vantage-theme-*)   printf '%s\n' "${1#luci-i18n-vantage-theme-}" ;;
        luci-i18n-vantage-aps-*)     printf '%s\n' "${1#luci-i18n-vantage-aps-}" ;;
        luci-i18n-vantage-traffic-*) printf '%s\n' "${1#luci-i18n-vantage-traffic-}" ;;
        luci-i18n-vantage-*)         printf '%s\n' "${1#luci-i18n-vantage-}" ;;
        *)                           return 1 ;;
    esac
}

# --- Discover available language packs ---
: > "$TMPDIR/langs_raw.txt"
while IFS= read -r url; do
    pkg="$(pkg_name_from_url "$url")"
    if lang="$(lang_from_pkg "$pkg" 2>/dev/null)"; then
        printf '%s\n' "$lang" >> "$TMPDIR/langs_raw.txt"
    fi
done < "$URLS_FILE"

sort -u "$TMPDIR/langs_raw.txt" > "$LANGS_FILE"
LANG_COUNT="$(wc -l < "$LANGS_FILE" | tr -d ' ')"

# Show currently installed languages (helpful when updating)
INSTALLED_LANGS="$(apk info 2>/dev/null | sed -n \
    -e 's/^luci-i18n-vantage-theme-//p; t' \
    -e 's/^luci-i18n-vantage-aps-//p; t' \
    -e 's/^luci-i18n-vantage-traffic-//p; t' \
    -e 's/^luci-i18n-vantage-//p' \
    | sort -u | tr '\n' ' ' | sed 's/ $//')"

if [ -n "$INSTALLED_LANGS" ]; then
    echo "Currently installed languages: $INSTALLED_LANGS"
fi

# --- Language selection prompt ---
SELECTED_LANGS=""

if [ "$LANG_COUNT" -eq 0 ]; then
    echo "No language packs found in this release. Installing core packages only."
else
    echo ""
    echo "Select language pack(s) to install/update:"
    echo "  0) None (English only)"
    i=1
    while IFS= read -r lang; do
        printf "  %d) %s\n" "$i" "$lang"
        i=$((i + 1))
    done < "$LANGS_FILE"
    echo "  a) All available languages"
    echo ""

    while :; do
        printf "Enter number(s) separated by space (e.g. 1 3), 0, or a: "
        if [ -r /dev/tty ]; then
            read -r RAW_CHOICE </dev/tty
        else
            read -r RAW_CHOICE
        fi

        CHOICE="$(printf '%s' "$RAW_CHOICE" | tr ',' ' ')"
        [ -z "$CHOICE" ] && continue

        case "$CHOICE" in
            0)
                SELECTED_LANGS=""
                break
                ;;
            a|A|all|ALL)
                SELECTED_LANGS="$(tr '\n' ' ' < "$LANGS_FILE")"
                break
                ;;
        esac

        VALID=1
        TEMP_SELECTED=""
        for token in $CHOICE; do
            case "$token" in
                *[!0-9]*)
                    if grep -Fxq "$token" "$LANGS_FILE"; then
                        TEMP_SELECTED="$TEMP_SELECTED $token"
                    else
                        echo "Invalid selection: '$token'. Please try again."
                        VALID=0
                        break
                    fi
                    ;;
                *)
                    if [ "$token" -ge 1 ] && [ "$token" -le "$LANG_COUNT" ]; then
                        picked="$(sed -n "${token}p" "$LANGS_FILE")"
                        TEMP_SELECTED="$TEMP_SELECTED $picked"
                    else
                        echo "Number out of range: '$token'. Please try again."
                        VALID=0
                        break
                    fi
                    ;;
            esac
        done

        if [ "$VALID" -eq 1 ]; then
            SELECTED_LANGS="$(printf '%s\n' $TEMP_SELECTED | sort -u | tr '\n' ' ')"
            break
        fi
    done
fi

# --- Download packages ---
echo ""
echo "Downloading packages..."

DOWNLOADED=0
while IFS= read -r url; do
    pkg="$(pkg_name_from_url "$url")"
    NEED=0

    case "$pkg" in
        luci-theme-vantage|luci-app-vantage|luci-app-vantage-aps|luci-app-vantage-traffic)
            NEED=1
            ;;
        luci-i18n-vantage-*)
            lang="$(lang_from_pkg "$pkg")"
            for sel in $SELECTED_LANGS; do
                [ "$sel" = "$lang" ] && NEED=1 && break
            done
            ;;
    esac

    if [ "$NEED" -eq 1 ]; then
        fname="${url##*/}"
        echo "  -> $fname"
        download_file "$url" "$PKG_DIR/$fname"
        DOWNLOADED=$((DOWNLOADED + 1))
    fi
done < "$URLS_FILE"

if [ "$DOWNLOADED" -eq 0 ]; then
    echo "Error: no matching packages found to download." >&2
    exit 1
fi

# --- Install / update ---
echo ""
echo "Updating apk package index..."
apk update || echo "Warning: 'apk update' failed, attempting local package installation..."

echo "Installing/updating packages (${DOWNLOADED} files)..."
apk add --allow-untrusted "$PKG_DIR"/*.apk

# Clear LuCI cache so theme and translations appear immediately
rm -rf /tmp/luci-indexcache* /tmp/luci-modulecache/

echo ""
echo "Done! Vantage (${VERSION:-latest}) installed/updated (theme + app + aps + traffic)."
if [ -n "$SELECTED_LANGS" ]; then
    echo "Installed languages: $SELECTED_LANGS"
fi
