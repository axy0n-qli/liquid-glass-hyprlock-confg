export LC_ALL=C.UTF-8

esc() {
    local s="${1//$'\n'/ }"
    s="${s//&/"&amp;"}"
    s="${s//</"&lt;"}"
    s="${s//>/"&gt;"}"
    printf '%s' "$s"
}

clip() {
    local s="${1//$'\n'/ }" max="$2" total=0 cut=0 i cp cw
    for (( i = 0; i < ${#s}; i++ )); do
        printf -v cp '%d' "'${s:i:1}"
        cw=1
        if (( (cp >= 0x1100 && cp <= 0x115F) || (cp >= 0x2E80 && cp <= 0xA4CF) || (cp >= 0xAC00 && cp <= 0xD7A3) \
            || (cp >= 0xF900 && cp <= 0xFAFF) || (cp >= 0xFE30 && cp <= 0xFE6F) || (cp >= 0xFF00 && cp <= 0xFF60) \
            || (cp >= 0xFFE0 && cp <= 0xFFE6) || (cp >= 0x1F300 && cp <= 0x1FAFF) || (cp >= 0x20000 && cp <= 0x3FFFD) )); then
            cw=2
        fi
        total=$(( total + cw ))
        (( total <= max - 1 )) && cut=$(( i + 1 ))
        (( total > max )) && break
    done
    if (( total <= max )); then
        printf '%s' "$s"
    else
        printf '%s…' "${s:0:cut}"
    fi
}
