#!/usr/bin/env sh
set -eu

# Removes the macOS app bundle and terminal command installed by install.sh.

if [ "$(uname -s)" != "Darwin" ]; then
    echo "Pied IDE currently supports macOS on Apple Silicon only."
    exit 1
fi

if [ -d "/Applications/Pied.app" ]; then
    rm -rf "/Applications/Pied.app"
fi

rm -f "$HOME/.local/bin/pied"

echo "Pied IDE has been uninstalled. Your editor settings and projects were left untouched."
