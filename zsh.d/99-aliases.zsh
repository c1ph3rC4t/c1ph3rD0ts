alias c='clear'

alias quit='exit'
alias q='exit'

alias ip='ip -c'

alias zshr='source ~/.zshrc'

alias ssh='TERM=xterm-256color ssh'

# File and directory managment
alias mkdir='mkdir -p'
alias rm='rm -r'

# Power
alias off='poweroff'
alias shutdown='poweroff'
alias shut='poweroff'
alias die='poweroff -f'

alias restart='reboot'

# Navigation
alias ..='cd ..'
alias ...='cd ../..'

alias .1='cd ..'
alias .2='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'

# Zoxide
if command -v zoxide &>/dev/null; then
    alias cd='z'
fi

# Yay
if [ -n "$AUR_HELPER" ]; then
    alias yoink="$AUR_HELPER -S"
    alias yank="$AUR_HELPER -Rns"
    alias yeet="$AUR_HELPER -Rns"
    alias yawn="$AUR_HELPER -Syu"
fi

# NixOS
if [ $DISTRO = "nixos" ]; then
    alias nixos-gens='sudo nix-env -p /nix/var/nix/profiles/system --list-generations'
    alias nixos-gc='sudo nix-collect-garbage -d'
    alias nixos-rb='sudo nixos-rebuild switch'
fi

# Eza
if command -v eza &>/dev/null; then
    alias lso='\ls --color'

    alias ls='eza'
    alias ls1='eza'
    alias ls2='eza -1TL 2'
    alias ls3='eza -1TL 3'
    alias ls4='eza -1TL 4'
    alias ls5='eza -1TL 5'

    alias l='eza -A'
    alias l1='eza -A'
    alias l2='eza -1ATL 2'
    alias l3='eza -1ATL 3'
    alias l4='eza -1ATL 4'
    alias l5='eza -1ATL 5'

    alias ll='eza -lAh --git'
    alias ll1='eza -lAh --git'
    alias ll2='eza -lAhTL 2 --git'
    alias ll3='eza -lAhTL 3 --git'
    alias ll4='eza -lAhTL 4 --git'
    alias ll5='eza -lAhTL 5 --git'
else
    alias ls='\ls --color'
fi

# Neovim
if command -v nvim &>/dev/null; then
    alias n='nvim'
    alias nano='nvim'
    alias vim='nvim'
    alias vi='nvim'
fi

# Yazi
if command -v yazi &>/dev/null; then
    alias y='yazi'
fi
