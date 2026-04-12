#!/bin/bash
# Dump only explicitly installed, top-level packages (not pulled in as deps)
yay -Qqet > "$(dirname "$0")/aur-deps"
