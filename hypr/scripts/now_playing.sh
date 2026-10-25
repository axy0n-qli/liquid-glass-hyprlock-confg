#!/bin/bash
. "$(dirname "$(readlink -f "$0")")/lib.sh"

title_cells=23
artist_cells=31
bar_max_cells=36
bar_cells=22
accent="#00e6ff"
dim="#666666"
muted="#cccccc"

format_time() {
    local total="$1"
    if [ "$total" -ge 3600 ]; then
        printf '%d:%02d:%02d' $(( total / 3600 )) $(( total % 3600 / 60 )) $(( total % 60 ))
    else
        printf '%d:%02d' $(( total / 60 )) $(( total % 60 ))
    fi
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

title=$(esc "$(clip "$title" "$title_cells")")
artist=$(esc "$(clip "$artist" "$artist_cells")")

position=$(playerctl position 2>/dev/null)
length=$(playerctl metadata mpris:length 2>/dev/null)
position=${position%%.*}
position=${position%%,*}

progress=""
if [[ "$position" =~ ^[0-9]+$ && "$length" =~ ^[0-9]+$ && "$length" -gt 0 ]]; then
    length=$(( length / 1000000 ))
    if [ "$length" -gt 0 ]; then
        [ "$position" -gt "$length" ] && position=$length
        elapsed=$(format_time "$position")
        total=$(format_time "$length")
        bar_width=$(( bar_max_cells - 4 - ${#elapsed} - ${#total} ))
        [ "$bar_width" -gt "$bar_cells" ] && bar_width=$bar_cells
        [ "$bar_width" -lt 6 ] && bar_width=6
        filled=$(( position * bar_width / length ))
        empty=$(( bar_width - filled ))
        on=$(printf '%*s' "$filled" '' | sed 's/ /━/g')
        off=$(printf '%*s' "$empty" '' | sed 's/ /─/g')
        progress=$(printf '<span size="9pt"><span foreground="%s">%s</span><span foreground="%s">%s</span> <span foreground="%s">%s / %s</span></span>' \
            "$accent" "$on" "$dim" "$off" "$muted" "$elapsed" "$total")
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
