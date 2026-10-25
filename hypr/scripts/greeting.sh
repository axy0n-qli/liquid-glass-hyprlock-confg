#!/bin/bash
. "$(dirname "$(readlink -f "$0")")/lib.sh"

hour=$((10#$(date +%H)))
if [ "$hour" -lt 5 ]; then
    greeting="Good night"
elif [ "$hour" -lt 12 ]; then
    greeting="Good morning"
elif [ "$hour" -lt 18 ]; then
    greeting="Good afternoon"
else
    greeting="Good evening"
fi

user=$(id -un)
name=$(getent passwd "$user" | cut -d: -f5 | cut -d, -f1)
[ -z "$name" ] && name="$user"

printf '%s, %s' "$greeting" "$(esc "$name")"
