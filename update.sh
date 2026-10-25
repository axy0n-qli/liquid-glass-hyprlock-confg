#!/bin/bash
set -e
cd "$(dirname "$(readlink -f "$0")")"
git pull --rebase origin main
echo "Updating..."
python3 ./scripts/install.py
