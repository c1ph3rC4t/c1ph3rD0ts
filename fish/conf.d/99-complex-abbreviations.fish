# Navigation
## Cd based nav
function dotdot_abbr
    set -l depth (math (string length -- $argv) - 1)
    echo cd (string repeat -n $depth '../')
end
abbr -a dotdot -r '^\.\.+$' -f dotdot_abbr

function dotnum_abbr
    set -l depth (string sub -s 2 -- $argv[1])
    echo cd (string repeat -n $depth '../')
end
abbr -a dotnum -r '^\.([1-9][0-9]*)$' -f dotnum_abbr

## Eza based nav
if command -q eza
    function lstree_abbr
        set -l depth (string sub -s 3 -- $argv[1])
        echo "eza -1TL$depth"
    end
    abbr -a lstree -r '^ls([1-9][0-9]*)$' -f lstree_abbr

    function ltree_abbr
        set -l depth (string sub -s 2 -- $argv[1])
        echo "eza -1ATL$depth"
    end
    abbr -a ltree -r '^l([1-9][0-9]*)$' -f ltree_abbr

    function lgtree_abbr
        set -l depth (string sub -s 3 -- $argv[1])
        echo "eza --git --git-ignore -1ATL$depth"
    end
    abbr -a lgtree -r '^lg([1-9][0-9]*)$' -f lgtree_abbr

    function lltree_abbr
        set -l depth (string sub -s 3 -- $argv[1])
        echo "eza --git --time-style "+%Y-%m-%d %H:%M" -loAhbTL$depth"
    end
    abbr -a lltree -r '^ll([1-9][0-9]*)$' -f lltree_abbr

    function llgtree_abbr
        set -l depth (string sub -s 4 -- $argv[1])
        echo "eza --git --git-ignore --time-style "+%Y-%m-%d %H:%M" -loAhbTL$depth"
    end
    abbr -a llgtree -r '^llg([1-9][0-9]*)$' -f llgtree_abbr
end

# Dealias
function dealias_abbr
    echo "command $(string sub -s 2 -- $argv)"
end
abbr -a dealias -r '^!.+$' -f dealias_abbr

# History
function exclexcl_abbr
    echo "$(history -n "$(math (string length -- $argv) - 1)" -R | head -n 1)"
end
abbr -a exclexcl -r '^\!\!+$' -f exclexcl_abbr

function exclnum_abbr
    echo "$(history -n "$(string sub -s 2 -- $argv)" -R | head -n 1)"
end
abbr -a exclnum -r '^\!([1-9][0-9]*)$' -f exclnum_abbr

# Sudo
function sudoify_abbr
    echo "sudo $(string sub -s 2 -- $argv)"
end
abbr -a sudoify -r '^§.*$' -f sudoify_abbr

# AUR helper
if test "$AUR_HELPER" != ''
    function aur_abbr
        echo "$AUR_HELPER -$(string sub -s 2 -- $argv)"
    end
    abbr -a aur -r '^y[A-Z]\w*$' -f aur_abbr
end
