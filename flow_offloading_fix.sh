#!/bin/sh
# =========================================
# FIX для Flow Offloading (часть Zapret-Manager by StressOzz)
# Zapret некорректно работает с включённым Flow Offloading —
# фикс исключает из offload соединения, обрабатываемые NFQWS.
# =========================================

R='\033[31m'; G='\033[32m'; Y='\033[33m'; C='\033[36m'; M='\033[35m'; N='\033[0m'
RULESET='/usr/share/firewall4/templates/ruleset.uc'
FIXED='meta l4proto { tcp, udp } ct original packets ge 30 flow offload @ft;'
PLAIN='meta l4proto { tcp, udp } flow offload @ft;'

[ "$(id -u)" = "0" ] || { echo -e "\n${R}Запустите скрипт от root!${N}\n"; exit 1; }
[ -f "$RULESET" ] || { echo -e "\n${R}Файл ${N}$RULESET ${R}не найден! Нужен OpenWrt с firewall4.${N}\n"; exit 1; }

if grep -q "$FIXED" "$RULESET"; then
    FIX=1
elif grep -q "$PLAIN" "$RULESET"; then
    FIX=0
else
    echo -e "\n${R}Не удалось найти правило flow offload в ${N}$RULESET${N}\n"; exit 1
fi

FO=$(uci -q get firewall.@defaults[0].flow_offloading)
FOHW=$(uci -q get firewall.@defaults[0].flow_offloading_hw)

if [ "$FIX" = "1" ]; then
    echo -e "\n${Y}FIX для Flow Offloading:${N} ${G}включён${N}"
    echo -ne "${Y}Выключить FIX? [y/N]: ${N}"; read -r A
    case "$A" in
        [yY]|[дД])
            echo -e "\n${M}Отключаем FIX для Flow Offloading${N}"
            sed -i "s/$FIXED/$PLAIN/" "$RULESET"
            fw4 restart >/dev/null 2>&1
            echo -e "FIX ${G}отключён!${N}\n"
            ;;
        *) echo -e "${G}Отмена${N}\n" ;;
    esac
elif [ "$FO" = "1" ] || [ "$FOHW" = "1" ]; then
    echo -e "\n${Y}FIX для Flow Offloading:${N} ${R}выключен${N}"
    echo -e "${R}Включён Flow Offloading! Zapret некорректно работает с включённым Flow Offloading!${N}"
    echo -ne "${Y}Включить FIX? [y/N]: ${N}"; read -r A
    case "$A" in
        [yY]|[дД])
            echo -e "\n${M}Применяем FIX для Flow Offloading${N}"
            sed -i "s/$PLAIN/$FIXED/" "$RULESET"
            fw4 restart >/dev/null 2>&1
            echo -e "FIX ${G}успешно применён!${N}\n"
            ;;
        *) echo -e "${G}Отмена${N}\n" ;;
    esac
else
    echo -e "\n${G}Flow Offloading выключен — FIX не требуется.${N}\n"
fi
