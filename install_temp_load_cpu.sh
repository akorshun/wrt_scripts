#!/bin/bash

wget --no-check-certificate -O /tmp/luci-app-temp-status.apk https://github.com/gSpotx2f/packages-openwrt/raw/refs/heads/master/25.12/luci-app-temp-status-0.8.1-r1.apk
apk --allow-untrusted add /tmp/luci-app-temp-status.apk
rm /tmp/luci-app-temp-status.apk
service rpcd restart
wget --no-check-certificate -O /tmp/luci-i18n-temp-status-ru.apk https://github.com/gSpotx2f/packages-openwrt/raw/refs/heads/master/25.12/luci-i18n-temp-status-ru-0.8.1-r1.apk
apk --allow-untrusted add /tmp/luci-i18n-temp-status-ru.apk
rm /tmp/luci-i18n-temp-status-ru.apk
wget --no-check-certificate -O /tmp/luci-app-cpu-status.apk https://github.com/gSpotx2f/packages-openwrt/raw/refs/heads/master/25.12/luci-app-cpu-status-0.6.3-r1.apk
apk --allow-untrusted add /tmp/luci-app-cpu-status.apk
rm /tmp/luci-app-cpu-status.apk
service rpcd reload
wget --no-check-certificate -O /tmp/luci-i18n-cpu-status-ru.apk https://github.com/gSpotx2f/packages-openwrt/raw/refs/heads/master/25.12/luci-i18n-cpu-status-ru-0.6.3-r1.apk
apk --allow-untrusted add /tmp/luci-i18n-cpu-status-ru.apk
rm /tmp/luci-i18n-cpu-status-ru.apk
