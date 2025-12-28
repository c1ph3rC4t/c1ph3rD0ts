# Navigation
## Cd based nav
function dotdot
    set -l depth (math (string length -- $argv) - 1)
    echo cd (string repeat -n $depth '../')
end
abbr -a dotdot -r '^\.\.+$' -f dotdot

function dotnum
    set -l depth (string sub -s 2 -- $argv[1])
    echo cd (string repeat -n $depth '../')
end
abbr -a dotnum -r '^\.([1-9][0-9]*)$' -f dotnum

## Eza based nav
if command -q eza
    function lstree
        set -l depth (string sub -s 3 -- $argv[1])
        echo "eza -1TL$depth"
    end
    abbr -a lstree -r '^ls([1-9][0-9]*)$' -f lstree

    function ltree
        set -l depth (string sub -s 2 -- $argv[1])
        echo "eza -1ATL$depth"
    end
    abbr -a ltree -r '^l([1-9][0-9]*)$' -f ltree

    function lltree
        set -l depth (string sub -s 3 -- $argv[1])
        echo "eza -lAhT@L$depth --git"
    end
    abbr -a lltree -r '^ll([1-9][0-9]*)$' -f lltree
end

# History
function exclexcl
    echo "$(history -n "$(math (string length -- $argv) - 1)" -R | head -n 1)"
end 
abbr -a exclexcl -r '^\!\!+$' -f exclexcl

function exclnum
    echo "$(history -n "$(string sub -s 2 -- $argv)" -R | head -n 1)"
end

abbr -a exclnum -r '^\!([1-9][0-9]*)$' -f exclnum
