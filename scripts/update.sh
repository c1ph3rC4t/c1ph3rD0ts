#!/usr/bin/env bash
# Update existing install — syncs packages, extensions, fonts, and services
# Usage: update.sh [-E|--skip-extensions]

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(git -C "$SCRIPT_DIR" rev-parse --show-toplevel)"
source "$SCRIPT_DIR/common.sh"

SKIP_EXTENSIONS=false
for arg in "$@"; do
    case "$arg" in
        --skip-extensions|-E) SKIP_EXTENSIONS=true ;;
    esac
done

if $SKIP_EXTENSIONS; then
    TOTAL_CHECKS=7
else
    TOTAL_CHECKS=8
fi

begin_check "Checking for dotfile updates"
    git -C "$REPO_DIR" fetch
    LOCAL=$(git -C "$REPO_DIR" rev-parse HEAD)
    REMOTE=$(git -C "$REPO_DIR" rev-parse @{u})
    if [ "$LOCAL" != "$REMOTE" ]; then
        git -C "$REPO_DIR" pull --ff-only
        warn "Dotfiles were updated. Review the changes before re-running:"
        git -C "$REPO_DIR" log --oneline "$LOCAL".."$REMOTE"
        exit 0
    fi
end_check

begin_check "Setting up git hooks"
    git -C "$REPO_DIR" config core.hooksPath .githooks
end_check

begin_check "Refreshing ClamAV"
    sudo pacman -S --needed --noconfirm clamav
    setup_clamav
end_check

begin_check "Updating packages"
    yay -Syu --noconfirm
end_check

begin_check "Installing packages"
    install_packages
end_check

if ! $SKIP_EXTENSIONS; then
    begin_check "Installing VSCode extensions"
        install_vscode_extensions
    end_check
fi

begin_check "Installing fonts"
    install_fonts
end_check

begin_check "Enabling services"
    setup_services
end_check

success
