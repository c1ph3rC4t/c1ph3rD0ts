# Suppress fish welcome message
set fish_greeting

# Set up $PATH
# Scripts
set -gx PATH $HOME/.config/scripts $PATH

# Java
set -gx PATH $JAVA_HOME/bin $PATH

# Cargo
set -gx PATH $HOME/.cargo/bin/ $PATH

# PNPM
set -gx PNPM_HOME $HOME/.local/share/pnpm
if not string match -q -- $PNPM_HOME $PATH
    set -gx PATH "$PNPM_HOME" $PATH
end

# Set up $TERM
set -gx TERM xterm-256color

# Set Node Version Manager path
set -gx NVM_DIR "$HOME/.nvm"

# Set DISTRO and DISTROLIKE variables safely
set -l _os_release (cat /etc/os-release 2>/dev/null; or cat /usr/lib/os-release 2>/dev/null)

# Makes Flatpak apps actually show up in application launchers
if not string match -q "*/var/lib/flatpak/exports/share*" $XDG_DATA_DIRS
    set -gx XDG_DATA_DIRS /var/lib/flatpak/exports/share $XDG_DATA_DIRS
end

if not string match -q "*$HOME/.local/share/flatpak/exports/share*" $XDG_DATA_DIRS
    set -gx XDG_DATA_DIRS $HOME/.local/share/flatpak/exports/share $XDG_DATA_DIRS
end

for line in $_os_release
    if string match -qr '^ID=' $line
        set -gx DISTRO (string replace 'ID=' '' $line)
    end

    if string match -qr '^ID_LIKE=' $line
        set -gx DISTROLIKE (string replace 'ID_LIKE=' '' $line)
    end
end

if not set -q DISTRO
    set -gx DISTRO unknown
end
if not set -q DISTROLIKE
    set -gx DISTROLIKE unknown
end

set -gx DISTRO (string trim --chars='"' $DISTRO)
set -gx DISTROLIKE (string trim --chars='"' $DISTROLIKE)

switch $DISTRO
    case arch
        set -gx DISTROICON ''
    case nixos
        set -gx DISTROICON ''
    case '*'
        switch $DISTROLIKE
            case arch
                set -gx DISTROICON ''
            case '*'
                set -gx DISTROICON ''
        end
end

# Set AUR helper variable
if command -q paru
    set -gx AUR_HELPER 'paru'
else if command -q yay
    set -gx AUR_HELPER 'yay'
else
    set -gx AUR_HELPER ''
end

# Set sudo prompt
function sudoprompt
    set_color 8caaee
    echo -ne "[sudo]  $USER "
    set_color c49bc4
    echo -ne "❯ "
    set_color normal
end

set -gx SUDO_PROMPT $(sudoprompt)

# Fish stuff
set -eU fish_key_bindings

set -g fish_color_autosuggestion brblack
set -g fish_color_cancel -r
set -g fish_color_command green
set -g fish_color_comment brblack
set -g fish_color_cwd green
set -g fish_color_cwd_root red
set -g fish_color_end green
set -g fish_color_error brred
set -g fish_color_escape brcyan
set -g fish_color_history_current --bold
set -g fish_color_host normal
set -g fish_color_host_remote yellow
set -g fish_color_normal normal
set -g fish_color_operator brcyan
set -g fish_color_param cyan
set -g fish_color_quote yellow
set -g fish_color_redirection cyan --bold
set -g fish_color_search_match white --background=brblack --bold
set -g fish_color_selection white --background=brblack --bold
set -g fish_color_status red
set -g fish_color_user brgreen
set -g fish_color_valid_path --underline
set -g fish_pager_color_background
set -g fish_pager_color_completion normal
set -g fish_pager_color_description yellow -i
set -g fish_pager_color_prefix normal --bold --underline
set -g fish_pager_color_progress brwhite --background=cyan --bold
set -g fish_pager_color_secondary_background
set -g fish_pager_color_secondary_completion
set -g fish_pager_color_secondary_description
set -g fish_pager_color_secondary_prefix
set -g fish_pager_color_selected_background -r
set -g fish_pager_color_selected_completion
set -g fish_pager_color_selected_description
set -g fish_pager_color_selected_prefix
