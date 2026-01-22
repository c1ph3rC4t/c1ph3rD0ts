#!/usr/bin/env bash
#\___________________,
# Cross platform bash

set -euo pipefail
#\____________________________,
# -e          => exit on error
# -u          => undefined var errors
# -o pipefail => fail if any pipeline command fails

trap 'echo -e "\n\n /!\\\\ AN ERROR OCCURRED /!\\\\\\n"' ERR
#\_____________,
# Error handler

configuring=true
. ./install.sh
configuring=
#\___________,
# Get configs

code --list-extensions | tee "./data/$VSCODE_EXTENSION_LIST_FILENAME"
#\________________________,
# Export VSCode extensions
