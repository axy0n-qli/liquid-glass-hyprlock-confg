#!/bin/bash
. "$(dirname "$(readlink -f "$0")")/lib.sh"

bar_width=22
accent="#00e6ff"
dim="#666666"
muted="#cccccc"

format_time() {
    printf '%d:%02d' $(( $1 / 60 )) $(( $1 % 60 ))
}

status=$(playerctl status 2>/dev/null)

if [ -z "$status" ]; then
    printf '󰎈 <b>Not playing</b>\n<span size="10pt" foreground="%s">No artist</span>\n<span size="10pt" foreground="%s">󰓛 Stopped</span>' "$muted" "$accent"
    exit 0
fi

title=$(playerctl metadata title 2>/dev/null)
artist=$(playerctl metadata artist 2>/dev/null)
[ -z "$title" ] && title="Unknown title"
[ -z "$artist" ] && artist="Unknown artist"

title=$(esc "$(clip "$title" 28)")
artist=$(esc "$(clip "$artist" 32)")

position=$(playerctl position 2>/dev/null)
length=$(playerctl metadata mpris:length 2>/dev/null)
position=${position%%.*}
position=${position%%,*}

progress=""
if [[ "$position" =~ ^[0-9]+$ && "$length" =~ ^[0-9]+$ && "$length" -gt 0 ]]; then
    length=$(( length / 1000000 ))
    if [ "$length" -gt 0 ]; then
        [ "$position" -gt "$length" ] && position=$length
        filled=$(( position * bar_width / length ))
        empty=$(( bar_width - filled ))
        on=$(printf '%*s' "$filled" '' | sed 's/ /▰/g')
        off=$(printf '%*s' "$empty" '' | sed 's/ /▱/g')
        progress=$(printf '<span size="9pt"><span foreground="%s">%s</span><span foreground="%s">%s</span> <span foreground="%s">%s / %s</span></span>' \
            "$accent" "$on" "$dim" "$off" "$muted" "$(format_time "$position")" "$(format_time "$length")")
    fi
fi

if [ "$status" = "Playing" ]; then
    state_icon="󰐊"
else
    state_icon="󰏤"
fi

printf '󰎈 <b>%s</b>\n<span size="10pt" foreground="%s">%s</span>\n' "$title" "$muted" "$artist"
[ -n "$progress" ] && printf '%s\n' "$progress"
printf '<span size="10pt" foreground="%s">%s %s</span>' "$accent" "$state_icon" "$status"
