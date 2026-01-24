# File and directory managment
abbr mkdir 'mkdir -p'

# Power
abbr off 'poweroff'
abbr shutdown 'poweroff'
abbr shut 'poweroff'
abbr die 'poweroff -f'

abbr restart 'reboot'

# Symlink
alias sym 'ln -s'
abbr usym 'unlink'
abbr unsym 'unlink'
abbr dsym 'unlink'
abbr desym 'unlink'

# Zoxide
if command -q zoxide
    abbr cd 'z'
end

# AUR helper
if test "$AUR_HELPER" != ''
    abbr yoink "$AUR_HELPER -S"
    abbr yank "$AUR_HELPER -Rns"
    abbr yeet "$AUR_HELPER -Rns"
    abbr yawn "$AUR_HELPER -Syu"
end

# NixOS
if test "$DISTRO" = 'nixos'
    alias nixos-gens 'sudo nix-env -p /nix/var/nix/profiles/system --list-generations'
    alias nixos-gc 'sudo nix-collect-garbage -d'
    alias nixos-rb 'sudo nixos-rebuild switch'
end

# Bat
if command -q bat
    abbr cat 'bat -pp'
end

# Eza
if command -q eza
    alias lso 'command ls --color'
    alias ls 'eza'
    alias l 'eza -A'
    alias lg 'eza --git-ignore -A'
    alias ll 'eza --git --time-style "+%Y-%m-%d %H:%M" -loAhb'
    alias llg 'eza --git --git-ignore --time-style "+%Y-%m-%d %H:%M" -loAhb'
    alias tmi 'eza --git --total-size --time-style full-iso --changed -laaSOniMXomUuhBZ@R'
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

# Fd
if command -q fd
    alias uzip 'fd -e zip -d 1 -x unzip {} -d {/.}'
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
