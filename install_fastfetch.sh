#!/bin/sh

wget --no-check-certificate -O /tmp/fastfetch.apk https://fantastic-packages.github.io/releases/25.12/packages/aarch64_generic/packages/fastfetch-2.61.0-r1.apk
apk --allow-untrusted add /tmp/fastfetch.apk
rm /tmp/fastfetch.apk
