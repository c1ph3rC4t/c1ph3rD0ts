#!/usr/bin/env bash
# Update existing install — syncs packages, extensions, fonts, and services

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

TOTAL_CHECKS=7

begin_check "Setting up git hooks"
    git -C "$SCRIPT_DIR" config core.hooksPath .githooks
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

success
