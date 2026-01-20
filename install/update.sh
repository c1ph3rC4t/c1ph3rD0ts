#!/usr/bin/env bash
#\___________________,
# Cross platform bash

set -euo pipefail
#\____________________________,
# -e          => exit on error
# -u          => undefined var errors
# -o pipefail => fail if any pipeline command fails

# Pull updates
git pull

# Install new deps
yay -S --needed --noconfirm $(cat ./deps)

# Install Code extensions
cat code-extensions | xargs -L 1 code --install-extension

# Install TTF fonts
sudo mkdir -p /usr/share/fonts/TTF
sudo cp ./TTF/*.ttf /usr/share/fonts/TTF/

# Install OTF fonts
sudo mkdir -p /usr/share/fonts/OTF
sudo cp ./OTF/*.otf /usr/share/fonts/OTF/

# Reload
sudo fc-cache -fv
