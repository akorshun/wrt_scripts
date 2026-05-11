#!/bin/sh
sed -i 's/action="add"/action="add --allow-untrusted"/g' /usr/libexec/package-manager-call
