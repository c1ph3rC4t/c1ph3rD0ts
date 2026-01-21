#!/usr/bin/env bash
#\___________________,
# Cross platform bash

set -euo pipefail
#\____________________________,
# -e          => exit on error
# -u          => undefined var errors
# -o pipefail => fail if any pipeline command fails

configuring=true
. ./install.sh
configuring=
#\___________,
# Get configs

code --list-extensions | tee "$VSCODE_EXTENSION_LIST_PATH"
#\________________________,
# Export VSCode extensions
