# Navigation
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
