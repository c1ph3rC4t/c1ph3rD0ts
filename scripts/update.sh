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

echo Setting up GIT hooks...
git config core.hooksPath .githooks
#\_______________,
# GIT hooks setup

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
cat "./data/$VSCODE_EXTENSION_LIST_FILENAME" | parallel --retries 10 --delay 1 -j 100% --line-buffer --tagstring '[{#}/'$total']' 'code --force --install-extension {}' 
#\_________________________,
# Install VSCode extensions

# Check if TTF directory exists
#/-----------------------------'
if [ -d "./data/TTF" ]; then 
    echo Installing TTF fonts...
    sudo mkdir -p /usr/share/fonts/TTF
    sudo xcp ./data/TTF/*.ttf /usr/share/fonts/TTF/
    #\_________________,
    # Install TTF fonts
fi

# Check if OTF directory exists
#/-----------------------------'
if [ -d "./data/OTF" ]; then 
    echo Installing OTF fonts...
    sudo mkdir -p /usr/share/fonts/OTF
    sudo xcp ./data/OTF/*.otf /usr/share/fonts/OTF/
    #\_________________,
    # Install OTF fonts
fi

echo Reloading cache...
sudo fc-cache -fv
#\____________,
# Reload cache

echo Setting up Docker systemd service...
sudo systemctl enable --now docker
#\____________,
# Docker setup

echo Setting up tailscale
sudo systemctl enable --now tailscaled
#\_______________,
# Tailscale setup

echo Setting up LY systemd service...
sudo systemctl enable ly@tty2.service
#\________,
# LY setup
