if [ -d /sys/class/power_supply/BAT0 ]; then
    notify-send "$(date) - $(cat /sys/class/power_supply/BAT0/capacity)% $(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep "energy-rate" | awk '{print $2}')W/$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep "energy:" | awk '{print $2}')Wh - $(nmcli device wifi list | grep '^\*' | awk '{print $3}' | grep -v '^$' || echo "disconnected")"
else
    notify-send "$(date)"
fi

