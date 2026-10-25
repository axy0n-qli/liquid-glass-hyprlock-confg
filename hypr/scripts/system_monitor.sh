#!/bin/bash
power_supply_dir="${POWER_SUPPLY_DIR:-/sys/class/power_supply}"

read -r _ u1 n1 s1 i1 w1 q1 sq1 st1 _ < /proc/stat
sleep 0.2
read -r _ u2 n2 s2 i2 w2 q2 sq2 st2 _ < /proc/stat

total=$(( (u2 + n2 + s2 + i2 + w2 + q2 + sq2 + st2) - (u1 + n1 + s1 + i1 + w1 + q1 + sq1 + st1) ))
idle=$(( (i2 + w2) - (i1 + w1) ))
cpu=0
[ "$total" -gt 0 ] && cpu=$(( 100 * (total - idle) / total ))

ram=$(awk '/^MemTotal/ {t=$2} /^MemAvailable/ {a=$2} END {printf "%.1fGB / %.1fGB", (t - a) / 1048576, t / 1048576}' /proc/meminfo)
disk=$(df -h / | awk 'NR==2 {printf "%s / %s (%s)", $3, $2, $5}')

battery=""
for bat in "$power_supply_dir"/BAT*; do
    [ -r "$bat/capacity" ] || continue
    capacity=$(cat "$bat/capacity")
    state=$(cat "$bat/status" 2>/dev/null)
    if [ "$state" = "Charging" ]; then
        icon="󰂄"
    elif [ "$capacity" -ge 95 ]; then
        icon="󰁹"
    elif [ "$capacity" -ge 80 ]; then
        icon="󰂂"
    elif [ "$capacity" -ge 60 ]; then
        icon="󰂀"
    elif [ "$capacity" -ge 40 ]; then
        icon="󰁾"
    elif [ "$capacity" -ge 20 ]; then
        icon="󰁼"
    else
        icon="󰁺"
    fi
    battery=$(printf '\n%s BAT: %s%%' "$icon" "$capacity")
    break
done

printf '<b>SYSTEM MONITOR</b>\n󰘚 CPU: %s%%\n󰍛 RAM: %s\n󰋊 DISK /: %s%s' "$cpu" "$ram" "$disk" "$battery"
