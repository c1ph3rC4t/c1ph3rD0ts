#!/usr/bin/env bash
# Shared config, progress output, and functions for install/update scripts

set -euo pipefail

# Config
COMMON_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO="https://github.com/c1ph3rC4t/c1ph3rD0ts"
TMP_DIR_NAME="c1ph3rD0ts"
TMP_DIR_PATH="/tmp/$TMP_DIR_NAME"
SCRIPTS_DIR_PATH="$TMP_DIR_PATH/scripts"
DATA_DIR="$COMMON_DIR/data"

# Progress tracking
DONE_CHECKS=0

begin_check() {
    echo -e " \x1b[1m\x1b[34m::\x1b[0m\x1b[1m [$DONE_CHECKS/$TOTAL_CHECKS] $*\x1b[0m"
    CURRENT_CHECK="$*"
}

end_check() {
    ((++DONE_CHECKS))
    echo -e " \x1b[1m\x1b[34m::\x1b[0m\x1b[1m $CURRENT_CHECK done\x1b[0m\n"
}

handle_error() {
    echo -e "\n \x1b[1m\x1b[31m::\x1b[0m\x1b[1m [$DONE_CHECKS/$TOTAL_CHECKS] $CURRENT_CHECK failed\x1b[0m\n"
}

success() {
    local rand=$(( $(od -An -tu4 -N4 /dev/urandom) % 10 ))
    if (( rand <= 0 )); then
        echo -e " \x1b[1m\x1b[35m::\x1b[0m\x1b[1m [$DONE_CHECKS/$TOTAL_CHECKS] All done! :3\x1b[0m"
    else
        echo -e " \x1b[1m\x1b[32m::\x1b[0m\x1b[1m [$DONE_CHECKS/$TOTAL_CHECKS] All done\x1b[0m"
    fi
}

trap 'handle_error > /dev/stderr' ERR

# Shared task functions

install_packages() {
    yay -S --needed --noconfirm $(<"$DATA_DIR/aur-deps")
}

install_vscode_extensions() {
    local total
    total=$(wc -l < "$DATA_DIR/vscode-extensions")
    parallel --retries 10 --delay 1 -j 100% --line-buffer \
        --tagstring "[{#}/$total]" \
        'code --force --install-extension {}' < "$DATA_DIR/vscode-extensions"
}

install_font_dir() {
    local fmt="$1"
    if [ -d "$DATA_DIR/$fmt" ]; then
        sudo mkdir -p "/usr/share/fonts/$fmt"
        sudo xcp "$DATA_DIR/$fmt/"*."${fmt,,}" "/usr/share/fonts/$fmt/"
        return 0
    fi
    return 1
}

install_fonts() {
    local installed=false
    install_font_dir TTF && installed=true
    install_font_dir OTF && installed=true
    if $installed; then
        sudo fc-cache -fv
    fi
}

setup_clamav() {
    sudo mkdir -p /etc/clamav/clamd.conf.d

    {
        echo "OnAccessIncludePath /home"
        echo "OnAccessIncludePath /var/cache/pacman/pkg"
        echo "OnAccessIncludePath /var/tmp/yay"
        for dir in /home/*/; do
            local user
            user=$(basename "$dir")
            echo "OnAccessExcludePath /home/$user/.config"
            echo "OnAccessExcludePath /home/$user/.local/share"
        done
        echo "OnAccessExcludeUname clamav"
        echo "OnAccessPrevention yes"
        echo "OnAccessExtraScanning yes"
    } | sudo tee /etc/clamav/clamd.conf.d/on-access.conf

    grep -q 'IncludeDir /etc/clamav/clamd.conf.d' /etc/clamav/clamd.conf || \
        echo 'IncludeDir /etc/clamav/clamd.conf.d' | sudo tee -a /etc/clamav/clamd.conf

    sudo freshclam
    sudo systemctl enable --now clamav-daemon clamav-freshclam clamonacc
}

setup_services() {
    sudo systemctl enable --now docker tailscaled
    sudo systemctl enable ly@tty2.service
}
