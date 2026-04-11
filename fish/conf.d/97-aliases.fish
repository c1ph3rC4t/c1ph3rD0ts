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
if command -q batcat
    alias bat 'batcat'
    abbr cat 'bat -pp'
end

# Xcp
if command -q xcp
    abbr cp 'xcp'
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
    alias uzip 'fd -e zip -e jar -d 1 -x unzip {} -d {/.}'
end
if command -q fdfind
    alias fd 'fdfind'
    alias uzip 'fdfind -e zip -e jar -d 1 -x unzip {} -d {/.}'
end

# Gunzip
if command -q gunzip
    alias gz 'gunzip'
end

# FFprobe
if command -q ffprobe
    alias fftracks 'ffprobe -hide_banner -show_entries stream=index,codec_type,codec_name:stream_tags=language,title -of compact'
end

# GCC C++
if command -q g++
    alias g+++ 'g++ -pipe -time -O2 -g -Wall -Werror=div-by-zero -Werror=array-bounds -Werror=overflow -Wextra -Wpedantic -Wconversion -Wformat=2 -fno-omit-frame-pointer -fstack-protector-strong -fdiagnostics-color=auto -DDEBUG -fchar8_t -o cppout'
end

# Misc.
alias c 'clear'

alias q 'exit'
alias quit 'exit'

alias reload 'exec fish'

alias ip 'ip -c'

alias clodd 'claude'
