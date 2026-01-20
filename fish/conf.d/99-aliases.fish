# File and directory managment
alias mkdir 'mkdir -p'

# Power
alias off 'poweroff'
alias shutdown 'poweroff'
alias shut 'poweroff'
alias die 'poweroff -f'

alias restart 'reboot'

# Symlink
alias sym 'ln -s'
alias usym 'unlink'
alias unsym 'unlink'
alias dsym 'unlink'
alias desym 'unlink'

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
    alias lso 'command ls --color'
    alias ls 'eza'
    alias l 'eza -A'
    alias ll 'eza -lAh@ --git'
else
    alias ls 'command ls --color'
    alias lso 'ls'
end

# Neovim
if command -q nvim
    alias n 'nvim'
    alias nano 'nvim'
    alias vim 'nvim'
    alias vi 'nvim'
end

# Arduino
if command -q arduino-cli
    alias ardc 'arduino-cli compile --fqbn arduino:avr:uno'
    alias ardu 'arduino-cli upload -p /dev/ttyACM0 --fqbn arduino:avr:uno'
    alias ardcu 'arduino-cli compile --fqbn arduino:avr:uno && arduino-cli upload -p /dev/ttyACM0 --fqbn arduino:avr:uno'
end

# Gunzip
if command -q gunzip
    alias gz 'gunzip'
end

# Misc.
alias c 'clear'

alias q 'exit'
alias quit 'exit'

alias reload 'exec fish'

alias ip 'ip -c'
