# Navigation
## Cd based nav
function dotdot
    set -l depth (math (string length -- $argv) - 1)
    echo cd (string repeat -n $depth '../')
end
abbr --add dotdot --regex '^\.\.+$' --function dotdot

function dotnum
    set -l depth (string sub -s 2 -- $argv[1])
    echo cd (string repeat -n $depth '../')
end
abbr --add dotnum --regex '^\.([1-9][0-9]*)$' --function dotnum

## Eza based nav
if command -q eza
    function lstree
        set -l depth (string sub -s 3 -- $argv[1])
        echo "eza -1TL$depth"
    end
    abbr --add lstree --regex '^ls([1-9][0-9]*)$' --function lstree

    function ltree
        set -l depth (string sub -s 2 -- $argv[1])
        echo "eza -1ATL$depth"
    end
    abbr --add ltree --regex '^l([1-9][0-9]*)$' --function ltree

    function lltree
        set -l depth (string sub -s 3 -- $argv[1])
        echo "eza -lAhT@L$depth --git"
    end
    abbr --add lltree --regex '^ll([1-9][0-9]*)$' --function lltree
end
