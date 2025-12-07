# Suppress fish welcome message
set fish_greeting

# Set up $PATH
# Scripts
set -gx PATH $HOME/.config/scripts $PATH

# Java
set -gx PATH $JAVA_HOME/bin $PATH

# Set up $TERM
set -gx TERM xterm-256color

# Set Node Version Manager path
set -gx NVM_DIR "$HOME/.nvm"

# Set DISTRO and DISTROLIKE variables safely
set -l _os_release (cat /etc/os-release 2>/dev/null; or cat /usr/lib/os-release 2>/dev/null)

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
