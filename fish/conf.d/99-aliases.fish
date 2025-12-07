# File and directory managment
alias mkdir 'mkdir -p'
alias rm 'rm -r'

# Power
alias off 'poweroff'
alias shutdown 'poweroff'
alias shut 'poweroff'
alias die 'poweroff -f'

alias restart 'reboot'

# Zoxide
if command -q zoxide
    alias cd 'z'
end

# AUR helper
if test "$AUR_HELPER" != ''
    alias yoink "$AUR_HELPER -S"
    alias yank "$AUR_HELPER -Rns"
    alias yeet "$AUR_HELPER -Rns"
    alias yawn "$AUR_HELPER -Syu"
end

# NixOS
if test "$DISTRO" = 'nixos'
    alias nixos-gens 'sudo nix-env -p /nix/var/nix/profiles/system --list-generations'
    alias nixos-gc 'sudo nix-collect-garbage -d'
    alias nixos-rb 'sudo nixos-rebuild switch'
end

# Eza
if command -q eza
    alias lso '\ls --color'
    alias ls 'eza'
    alias l 'eza -A'
    alias ll 'eza -lAh@ --git'
else
    alias ls '\ls --color'
    alias lso '\ls --color'
end

# Neovim
if command -q nvim
    alias n 'nvim'
    alias nano 'nvim'
    alias vim 'nvim'
    alias vi 'nvim'
end

# Yazi
if command -q yazi
    alias y 'yazi'
end

# Fd
if command -q fd
    alias f 'fd'
    alias find 'fd'
end

# Arduino
if command -q arduino-cli
    alias ardc 'arduino-cli compile --fqbn arduino:avr:uno'
    alias ardu 'arduino-cli upload -p /dev/ttyACM0 --fqbn arduino:avr:uno'
    alias ardcu 'arduino-cli compile --fqbn arduino:avr:uno && arduino-cli upload -p /dev/ttyACM0 --fqbn arduino:avr:uno'
end

# Misc.
alias c 'clear'

alias q 'exit'
alias quit 'exit'

alias ip 'ip -c'
