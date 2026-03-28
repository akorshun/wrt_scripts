#!/bin/sh

cat > /etc/rc.local << 'EOF'
# Put your custom commands here that should be executed once
# the system init finished. By default this file does nothing.
echo performance > /sys/module/pcie_aspm/parameters/policy
echo performance > /sys/devices/system/cpu/cpufreq/policy0/scaling_governor
echo performance > /sys/devices/system/cpu/cpufreq/policy1/scaling_governor
echo performance > /sys/devices/system/cpu/cpufreq/policy2/scaling_governor
echo performance > /sys/devices/system/cpu/cpufreq/policy3/scaling_governor
echo performance > /sys/devices/system/cpu/cpufreq/policy4/scaling_governor
echo performance > /sys/devices/system/cpu/cpufreq/policy5/scaling_governor
echo performance > /sys/devices/system/cpu/cpufreq/policy6/scaling_governor
echo performance > /sys/devices/system/cpu/cpufreq/policy7/scaling_governor

exit 0
EOF
