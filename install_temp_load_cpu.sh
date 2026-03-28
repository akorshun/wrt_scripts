#!/bin/bash

wget --no-check-certificate -O /tmp/luci-app-temp-status-0.8.0-r1.apk https://github.com/gSpotx2f/packages-openwrt/raw/master/25.12/luci-app-temp-status-0.8.0-r1.apk
apk --allow-untrusted add /tmp/luci-app-temp-status-0.8.0-r1.apk
rm /tmp/luci-app-temp-status-0.8.0-r1.apk
service rpcd restart
wget --no-check-certificate -O /tmp/luci-i18n-temp-status-ru-0.8.0-r1.apk https://github.com/gSpotx2f/packages-openwrt/raw/master/25.12/luci-i18n-temp-status-ru-0.8.0-r1.apk
apk --allow-untrusted add /tmp/luci-i18n-temp-status-ru-0.8.0-r1.apk
rm /tmp/luci-i18n-temp-status-ru-0.8.0-r1.apk
wget --no-check-certificate -O /tmp/luci-app-cpu-status-0.6.2-r1.apk https://github.com/gSpotx2f/packages-openwrt/raw/master/25.12/luci-app-cpu-status-0.6.2-r1.apk
apk --allow-untrusted add /tmp/luci-app-cpu-status-0.6.2-r1.apk
rm /tmp/luci-app-cpu-status-0.6.2-r1.apk
service rpcd reload
wget --no-check-certificate -O /tmp/luci-i18n-cpu-status-ru-0.6.2-r1.apk https://github.com/gSpotx2f/packages-openwrt/raw/master/25.12/luci-i18n-cpu-status-ru-0.6.2-r1.apk
apk --allow-untrusted add /tmp/luci-i18n-cpu-status-ru-0.6.2-r1.apk
rm /tmp/luci-i18n-cpu-status-ru-0.6.2-r1.apk
