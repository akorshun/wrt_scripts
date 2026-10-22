#!/bin/sh

wget --no-check-certificate -O /tmp/argon_theme.apk https://github.com/akorshun/wrt_scripts/raw/refs/heads/main/argon_theme.apk
apk --allow-untrusted add /tmp/argon_theme.apk
rm /tmp/argon_theme.apk
