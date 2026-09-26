#!/bin/bash
set -e
git pull --rebase origin main    
echo "Updating..."
python3 ./scripts/install.py
