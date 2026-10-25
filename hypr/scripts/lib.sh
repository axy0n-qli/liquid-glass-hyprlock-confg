export LC_ALL=C.UTF-8

esc() {
    local s="${1//$'\n'/ }"
    s="${s//&/"&amp;"}"
    s="${s//</"&lt;"}"
    s="${s//>/"&gt;"}"
    printf '%s' "$s"
}

clip() {
    local s="${1//$'\n'/ }" max="$2"
    if [ "${#s}" -gt "$max" ]; then
        printf '%s…' "${s:0:$((max - 1))}"
    else
        printf '%s' "$s"
    fi
}
