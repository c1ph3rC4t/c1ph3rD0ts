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

git pull
#\____________,
# Pull updates

echo Making sure all AUR packages are up to date...
yay -Syu --noconfirm
#\___________________________,
# Make sure yay is up to date

echo Installing Pacman and AUR dependencies...
yay -S --needed --noconfirm $(cat $AUR_DEPS_PATH)
#\_________________________,
# Install Pacman & AUR deps

echo Installing VSCode extensions...
total=$(wc -l < "./data/$VSCODE_EXTENSION_LIST_FILENAME")                                                                                                                                                                                                         
cat "./data/$VSCODE_EXTENSION_LIST_FILENAME" | parallel -j 100% --line-buffer --tagstring '[{#}/'$total']' 'code --force --install-extension {}' 
#\_________________________,
# Install VSCode extensions

echo Installing TTF fonts...
sudo mkdir -p /usr/share/fonts/TTF
sudo cp ./data/TTF/*.ttf /usr/share/fonts/TTF/
#\_________________,
# Install TTF fonts

echo Installing OTF fonts...
sudo mkdir -p /usr/share/fonts/OTF
sudo cp ./data/OTF/*.otf /usr/share/fonts/OTF/
#\_________________,
# Install OTF fonts

echo Reloading cache...
sudo fc-cache -fv
#\____________,
# Reload cache
