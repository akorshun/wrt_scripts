# wrt_scripts

## Installation notes

**Allow untrusted apk from web**

    wget -O - https://raw.githubusercontent.com/akorshun/wrt_scripts/main/allow_untrusted_apk_from_web.sh | sh

**Argon theme**

    wget -O - https://raw.githubusercontent.com/akorshun/wrt_scripts/main/install_argon_theme.sh | sh

**Vantage theme (OpenWrt 25.12+, apk)**

    wget -O - https://raw.githubusercontent.com/akorshun/wrt_scripts/main/install_vantage_theme.sh | sh

Installs or updates the latest [luci-theme-vantage](https://github.com/anothaDev/luci-theme-vantage) release (`luci-theme-vantage`, `luci-app-vantage`, `luci-app-vantage-aps`, `luci-app-vantage-traffic`). After starting, the script prompts you to select language pack(s) to install: enter `0` for none (English only), `a` for all available languages, or one/more numbers (or language codes like `ru`) separated by spaces.

**CPU temp and load**

    wget -O - https://raw.githubusercontent.com/akorshun/wrt_scripts/main/install_temp_load_cpu.sh | sh

**fancontrol**

    wget -O - https://raw.githubusercontent.com/akorshun/wrt_scripts/main/install_fancontrol.sh | sh
    uci set fancontrol.settings.fan_file='/sys/class/hwmon/hwmon11/pwm1'
    uci commit fancontrol
    /etc/init.d/fancontrol restart

**Fastfetch**

    wget -O - https://raw.githubusercontent.com/akorshun/wrt_scripts/main/install_fastfetch.sh | sh

**netstat**

    wget -O - https://raw.githubusercontent.com/akorshun/wrt_scripts/main/install_netstat.sh | sh

**Set Perf Profile Rockchip**

    wget -O - https://raw.githubusercontent.com/akorshun/wrt_scripts/main/set_perf_profile_rockchip.sh | sh

**Disable V6 and reboot**

    wget -O - https://raw.githubusercontent.com/akorshun/wrt_scripts/main/disable_v6_and_reboot.sh | sh

**Expand root and reboot**

    wget -O - https://raw.githubusercontent.com/akorshun/wrt_scripts/main/expand_root.sh | sh

**TorrServer**

    wget -O - https://raw.githubusercontent.com/Sanchopance/Routerich/refs/heads/main/TSinstall.sh | sh

**Podkop**

    sh <(wget -O - https://raw.githubusercontent.com/itdoginfo/podkop/refs/heads/main/install.sh)

**Zapret-Manager**

    sh <(wget -O - https://raw.githubusercontent.com/StressOzz/Zapret-Manager/main/Zapret-Manager.sh)

**Zapret Flow Offloading FIX**

    sh <(wget -O - https://raw.githubusercontent.com/akorshun/wrt_scripts/main/flow_offloading_fix.sh)
