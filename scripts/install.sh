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

REPO="https://github.com/c1ph3rC4t/c1ph3rD0ts"
TMP_DIR_NAME="c1ph3rD0ts"
AUR_DEPS_PATH="./data/aur-deps"
VSCODE_EXTENSION_LIST_FILENAME="vscode-extensions"

START_DIR=$(pwd)
TMP_DIR_PATH="/tmp/$TMP_DIR_NAME"
SCRIPTS_DIR_PATH="$TMP_DIR_PATH/scripts"
VSCODE_EXTENSION_LIST_PATH="$SCRIPTS_DIR_PATH/data/$VSCODE_EXTENSION_LIST_FILENAME"
#\_______________,
# Set config vars

# Check if being used as config script
#/------------------------------------'
if [ "$configuring" = "true" ]; then
    return 0
    #\___________,
    # Exit script
fi

echo Making sure all Pacman packages are up to date...
sudo pacman -Syu --noconfirm
#\______________________________,
# Make sure pacman is up to date

echo Installing install deps...
sudo pacman -S --noconfirm git gnupg
#\_______________________,
# Installing install deps

echo Loading GPG keys...
gpg --auto-key-locate nodefault,wkd --locate-keys torbrowser@torproject.org
#\_________________________________,
# Load GPG keys rquired for install

echo Cloning repo...
cd /tmp
rm -rf $TMP_DIR_NAME
git clone "$REPO" "$TMP_DIR_NAME"
cd "$SCRIPTS_DIR_PATH/"
#\_________________________,
# Clone GIT repo into /tmp/

echo Making sure yay is installed...
command -v yay &> /dev/null || (
    cd /tmp/ && git clone https://aur.archlinux.org/yay.git
    cd /tmp/yay/
    makepkg -si
    cd "$SCRIPTS_DIR_PATH/"
    rm -rf yay
)
#\__________________________,
# Make sure yay is installed

echo Making sure all AUR packages are up to date...
yay -Syu --noconfirm
#\___________________________,
# Make sure yay is up to date

echo Installing Pacman and AUR dependencies...
yay -S --needed --noconfirm $(cat "$AUR_DEPS_PATH")
#\_________________________,
# Install Pacman & AUR deps

echo Installing VSCode extensions...
total=$(wc -l < "./data/$VSCODE_EXTENSION_LIST_FILENAME")                                                                                                                                                                                                         
cat "./data/$VSCODE_EXTENSION_LIST_FILENAME" | parallel --retries 10 --delay 1 -j 1000 --line-buffer --tagstring '[{#}/'$total']' 'code --force --install-extension {}' 
#\_________________________,
# Install VSCode extensions

# Check if TTF directory exists
#/-----------------------------'
if [ -d "$SCRIPTS_DIR_PATH/data/TTF" ]; then 
    echo Installing TTF fonts...
    sudo mkdir -p /usr/share/fonts/TTF
    sudo xcp $SCRIPTS_DIR_PATH/data/*.ttf /usr/share/fonts/TTF/
    #\_________________,
    # Install TTF fonts
fi

# Check if OTF directory exists
#/-----------------------------'
if [ -d "$SCRIPTS_DIR_PATH/data/OTF" ]; then 
    echo Installing OTF fonts...
    sudo mkdir -p /usr/share/fonts/OTF
    sudo xcp $SCRIPTS_DIR_PATH/data/*.otf /usr/share/fonts/OTF/
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

echo Setting up LY systemd service...
sudo systemctl enable ly@tty2.service
#\________,
# LY setup

echo Setting up Rust toolchain and targets...
rustup toolchain add stable
rustup default stable
rustup target add x86_64-pc-windows-gnu
#\_____________________________,
# Rustup toolchains and targets

echo Configuring GIT...
cat $HOME/.gitconfig
echo -e "[include]\n\tpath = ~/.config/gitconfig\n$(cat "$HOME/.gitconfig")" | tee -a $HOME/.gitconfig
#\_____________,
# Configure GIT

echo Configuring Claude code...
mkdir -p ~/.claude
echo -e '{\n  "autoUpdates": false\n}' > ~/.claude/settings.json
#\___________,
# Claude code

cd "$TMP_DIR_PATH/"
#\_______________________,
# Move out of install dir

echo Backing up current dot files...
mv $HOME/.config/ $HOME/.config.bak/
mkdir -p $HOME/.config/
#\_______________________,
# Backing up current dots

echo Copying over dot files...
cp -r $TMP_DIR_PATH/* ~/.config/
cp -r $TMP_DIR_PATH/.[!.]* ~/.config/
#\_________________,
# Copying over dots

echo Cleaning up...
cd /tmp/
rm -rf "$TMP_DIR_PATH/"
#\________,
# Clean up

echo -e "If you are interested in gaming on linux please run:\ncurl -fsSL \"https://c1ph3rc4t.github.io/gaming-on-linux/main.sh\" | sh"
#\________________,
# Advertizing lmao
