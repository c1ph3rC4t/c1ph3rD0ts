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

git pull
#\____________,
# Pull updates

echo Installing Pacman and AUR dependencies...
yay -S --needed --noconfirm $(cat $AUR_DEPS_PATH)
#\_________________________,
# Install Pacman & AUR deps

echo Installing VSCode extensions...
cat "$VSCODE_EXTENSTION_LIST_PATH" | xargs -L 1 code --install-extension
#\______,
# VSCode

echo Installing TTF fonts...
sudo mkdir -p /usr/share/fonts/TTF
sudo cp ./TTF/*.ttf /usr/share/fonts/TTF/
#\_________________,
# Install TTF fonts

echo Installing OTF fonts...
sudo mkdir -p /usr/share/fonts/OTF
sudo cp ./OTF/*.otf /usr/share/fonts/OTF/
#\_________________,
# Install OTF fonts

echo Reloading cache...
sudo fc-cache -fv
#\____________,
# Reload cache
