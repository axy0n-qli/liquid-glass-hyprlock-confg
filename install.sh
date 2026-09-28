#!/bin/bash
set -e

chmod +x ./scripts/install-files.sh
python3 scripts/initial-install.py
python3 scripts/requiment.py
python3 scripts/install.py