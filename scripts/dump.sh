#!/usr/bin/env bash
# Dump only explicitly installed, top-level packages (not pulled in as deps)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
yay -Qqet > "$SCRIPT_DIR/data/aur-deps"
code --list-extensions > "$SCRIPT_DIR/data/vscode-extensions"
