#!/usr/bin/env bash
#\___________________,
# Cross platform bash

set -euo pipefail
#\____________________________,
# -e          => exit on error
# -u          => undefined var errors
# -o pipefail => fail if any pipeline command fails

REPO="https://github.com/c1ph3rC4t/c1ph3rD0ts"
TMP_DIR_NAME="c1ph3rD0ts"
AUR_DEPS_PATH="./aur-deps"
VSCODE_EXTENSION_LIST_FILENAME="vscode-extensions"

START_DIR=$(pwd)
TMP_DIR_PATH="/tmp/$TMP_DIR_NAME"
INSTALL_DIR_PATH="$TMP_DIR_PATH/install/"
VSCODE_EXTENSION_LIST_PATH="$INSTALL_DIR_PATH$VSCODE_EXTENSION_LIST_FILENAME"
#\_______________,
# Set config vars

# Check if being used as config script
#/------------------------------------'
if [ "$configuring" = "true" ]; then
    return 0
    #\___________,
    # Exit script
fi

echo Cloning repo...
cd /tmp
rm -rf $TMP_DIR_NAME
git clone "$REPO" "$TMP_DIR_NAME"
cd "$INSTALL_DIR_PATH"
#\_________________________,
# Clone GIT repo into /tmp/

echo Making sure all Pacman packages are up to date...
sudo pacman -Syu --noconfirm
#\______________________________,
# Make sure pacman is up to date

echo Making sure yay is installed...
command -v yay &> /dev/null || (
    cd /tmp/ && git clone https://aur.archlinux.org/yay.git
    cd /tmp/yay/
    makepkg -si
    cd "$INSTALL_DIR_PATH"
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
cat "" | xargs -L 1 code --install-extension
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

echo Setting up LY systemd service...
systemctl enable ly@tty2.service
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
mv -r $HOME/.config/ $HOME/.config.bak/
mkdir -p $HOME/.config/
#\_______________________,
# Backing up current dots

echo Copying over dot files...
cp -r "$TMP_DIR_PATH/*" ~/.config/
cp -r "$TMP_DIR_PATH/.[!.]*" ~/.config/
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
