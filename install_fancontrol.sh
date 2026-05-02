#!/bin/sh

wget --no-check-certificate -O /tmp/fancontrol.apk https://github.com/akorshun/wrt_scripts/raw/refs/heads/main/fancontrol-1-r3.apk
apk --allow-untrusted add /tmp/fancontrol.apk
rm /tmp/fancontrol.apk

wget --no-check-certificate -O /tmp/luci-app-fancontrol.apk https://github.com/akorshun/wrt_scripts/raw/refs/heads/main/luci-app-fancontrol-1.0-r1.apk
apk --allow-untrusted add /tmp/luci-app-fancontrol.apk
rm /tmp/luci-app-fancontrol.apk

wget --no-check-certificate -O /tmp/luci-i18n-fancontrol-ru.apk https://github.com/akorshun/wrt_scripts/raw/refs/heads/main/luci-i18n-fancontrol-ru-0.260502.45448.apk
apk --allow-untrusted add /tmp/luci-i18n-fancontrol-ru.apk
rm /tmp/luci-i18n-fancontrol-ru.apk
