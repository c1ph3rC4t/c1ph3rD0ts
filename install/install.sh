#!/bin/bash

# Config
REPO="https://github.com/c1ph3rC4t/c1ph3rD0ts"

# Clone
cd /tmp
rm -rf c1ph3rD0ts
git clone "$REPO"
cd c1ph3rD0ts/install

# Deps
sudo pacman -Syu

command -v yay &> /dev/null || (git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si && cd .. && rm -rf yay)

yay -Syu --needed $(cat ./deps)

# Setup
rustup toolchain add stable
rustup default stable
rustup target add x86_64-pc-windows-gnu

systemctl enable ly@tty2.service
mkdir -p ~/.claude
echo -e '{\n  "autoUpdates": false\n}' > ~/.claude/settings.json

# Moving dots
cp -r ~/.config ~/.config.bak
cd ..
cp -r ./* ~/.config/
cp -r ./.[!.]* ~/.config/

# Advertizing lmao
echo -e "If you are interested in gaming on linux please run:\ncurl -fsSL \"https://c1ph3rc4t.github.io/gaming-on-linux/main.sh\" | sh"
