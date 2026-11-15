#!/bin/sh

wget --no-check-certificate -O /tmp/argon_theme.apk https://raw.githubusercontent.com/akorshun/wrt_scripts/main/argon_theme.apk
apk --allow-untrusted add /tmp/argon_theme.apk
rm /tmp/argon_theme.apk
