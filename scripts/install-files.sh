#!/bin/bash
set -e
cd "$(dirname "$(readlink -f "$0")")/.."

target="${XDG_CONFIG_HOME:-$HOME/.config}/hypr"
stamp=$(date +%Y%m%d-%H%M%S)

mkdir -p "$target/scripts"

for file in hyprlock.conf hypridle.conf; do
    if [ -f "$target/$file" ]; then
        cp "$target/$file" "$target/$file.bak-$stamp"
        echo "Backup: $target/$file.bak-$stamp"
    fi
done

cp -r ./hypr/. "$target/"
chmod +x "$target"/scripts/*.sh
echo "Installed to $target"
