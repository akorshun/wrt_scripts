#!/bin/bash

wget  --no-check-certificate -O /tmp/netstat.apk "https://github.com/nooblk-98/luci-app-netstat/releases/download/v1.1.5-24/luci-app-netstat-1.1.5-r24.apk"
apk --allow-untrusted add /tmp/netstat.apk
rm /tmp/netstat.apk
