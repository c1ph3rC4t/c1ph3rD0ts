# Set up zsh history
HISTFILE=$HOME/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

# Set up $PATH
source $HOME/.config/zsh/paths.zsh

export TERM=xterm-256color

# Set Node Version Manager path
export NVM_DIR="$HOME/.nvm"

# Set DISTRO and DISTRO_LIKE variables
export DISTRO=$(
    if [ -f /etc/os-release ]; then
        . /etc/os-release 2>/dev/null && echo "${ID:-unknown}"
    elif [ -f /usr/lib/os-release ]; then
        . /usr/lib/os-release 2>/dev/null && echo "${ID:-unknown}"
    else
        echo "unknown"
    fi
)

export DISTRO_LIKE=$(
    if [ -f /etc/os-release ]; then
        . /etc/os-release 2>/dev/null && echo "${ID_LIKE:-unknown}"
    elif [ -f /usr/lib/os-release ]; then
        . /usr/lib/os-release 2>/dev/null && echo "${ID_LIKE:-unknown}"
    else
        echo "unknown"
    fi
)

case "$DISTRO" in
    arch)
        DISTROICON=""
        ;;
    nixos)
        DISTROICON=""
        ;;
    *)
        case "$DISTRO_LIKE" in
            arch)
                DISTROICON=""
                ;;
            *)
                DISTROICON=""
                ;;
        esac
        ;;
esac

# Set AUR helper variable
if [ -z "$AUR_HELPER" ]; then
    if command -v paru >/dev/null 2>&1; then
        AUR_HELPER="paru"
    elif command -v yay >/dev/null 2>&1; then
        AUR_HELPER="yay"
    else
        AUR_HELPER=""
    fi
fi
