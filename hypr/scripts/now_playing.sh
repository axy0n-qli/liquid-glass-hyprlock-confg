#!/bin/bash
truncate() {
    local str="$1" max="$2"
    if [ "${#str}" -gt "$max" ]; then
        echo "${str:0:$((max-1))}…"
    else
        echo "$str"
    fi
}

title=$(playerctl metadata title 2>/dev/null)
artist=$(playerctl metadata artist 2>/dev/null)
[ -z "$title" ] && title="Not playing"
[ -z "$artist" ] && artist="No artist"

title=$(truncate "$title" 28)
artist=$(truncate "$artist" 32)

printf "󰎈 <b>%s</b>\n<span size='10pt' foreground='#cccccc'>%s</span>" "$title" "$artist"