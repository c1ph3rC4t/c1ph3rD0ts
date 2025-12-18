#!/bin/bash

# Config
REPO="https://github.com/c1ph3rC4t/c1ph3rD0ts"

# Clone
cd /tmp
rm -rf c1ph3rD0ts
git clone "$REPO"
cd c1ph3rD0ts/install

# Deps
sudo pacman -Syu --needed $(cat ./pac-deps)

command -v yay &> /dev/null || (git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si && cd .. && rm -rf yay)

yay -Syu --needed $(cat ./aur-deps)

# Themeing
chmod +x ./slot.sh
./slot.sh

cp -r ~/.config ~/.config.bak
cd ..
cp -r ./* ~/.config/
cp -r ./.[!.]* ~/.config/
