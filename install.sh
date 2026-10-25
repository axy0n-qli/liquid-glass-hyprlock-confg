#!/bin/bash
set -e
cd "$(dirname "$(readlink -f "$0")")"
chmod +x ./scripts/install-files.sh
python3 scripts/requiment.py
python3 scripts/install.py
