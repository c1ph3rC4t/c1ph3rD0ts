#!/usr/bin/env bash
#\___________________,
# Cross platform bash

set -euo pipefail
#\____________________________,
# -e          => exit on error
# -u          => undefined var errors
# -o pipefail => fail if any pipeline command fails

# Export Code extensions
code --list-extensions | tee code-extensions
