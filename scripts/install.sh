#!/usr/bin/env bash
# Fresh system install — clones dotfiles repo, installs everything from scratch

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

TOTAL_CHECKS=15

begin_check "Updating pacman"
    sudo pacman -Syu --noconfirm
end_check

begin_check "Installing bootstrap deps"
    sudo pacman -S --noconfirm git gnupg
end_check

begin_check "Loading GPG keys"
    gpg --auto-key-locate nodefault,wkd --locate-keys torbrowser@torproject.org
end_check

begin_check "Cloning dotfiles repo"
    cd /tmp
    rm -rf "$TMP_DIR_NAME"
    git clone "$REPO" "$TMP_DIR_NAME"
    cd "$SCRIPTS_DIR_PATH/"
    DATA_DIR="$SCRIPTS_DIR_PATH/data"
end_check

begin_check "Bootstrapping yay"
    command -v yay &> /dev/null || (
        cd /tmp && git clone https://aur.archlinux.org/yay.git
        cd /tmp/yay/ && makepkg -si
        rm -rf /tmp/yay
    )
end_check

begin_check "Updating packages"
    yay -Syu --noconfirm
end_check

begin_check "Installing packages"
    install_packages
end_check

begin_check "Installing VSCode extensions"
    install_vscode_extensions
end_check

begin_check "Installing fonts"
    install_fonts
end_check

begin_check "Setting up ClamAV"
    setup_clamav
end_check

begin_check "Enabling services"
    setup_services
end_check

begin_check "Setting up Rust toolchain"
    rustup default stable
    rustup target add x86_64-pc-windows-gnu
end_check

begin_check "Configuring git and Claude Code"
    cat "$HOME/.gitconfig"
    echo -e "[include]\n\tpath = ~/.config/gitconfig\n$(cat "$HOME/.gitconfig")" | tee -a "$HOME/.gitconfig"
    mkdir -p ~/.claude
    echo -e '{\n  "autoUpdates": false\n}' > ~/.claude/settings.json
end_check

begin_check "Installing dotfiles"
    cd "$TMP_DIR_PATH/"
    mv "$HOME/.config/" "$HOME/.config.bak/"
    mkdir -p "$HOME/.config/"
    cp -r "$TMP_DIR_PATH/"* ~/.config/
    cp -r "$TMP_DIR_PATH/."[!.]* ~/.config/
    rm -rf "$TMP_DIR_PATH/"
end_check

begin_check "Setting up git hooks"
    git -C "$HOME/.config" config core.hooksPath .githooks
end_check

success

echo -e "\nIf you are interested in gaming on linux please run:"
echo 'curl -fsSL "https://c1ph3rc4t.github.io/gaming-on-linux/main.sh" | sh'
