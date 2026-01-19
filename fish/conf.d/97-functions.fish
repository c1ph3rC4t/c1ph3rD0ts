# Yazi shell wrapper
if command -q yazi
    function y
        set tmp (mktemp -t "yazi-cwd.XXXXXX")
        yazi $argv --cwd-file="$tmp"
        if read -z cwd < "$tmp"; and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
            builtin cd -- "$cwd"
        end
        rm -f -- "$tmp"
    end
end

# Disk managment
function burn
    sudo dd if=$argv[1] of=$argv[2] bs=4M status=progress conv=fsync
end

# Function to check if the first arg contains any of the other args
function contains_any
    set str $argv[1]
    set patterns $argv[2..-1]
    
    for p in $patterns
        set escaped (string escape --style=regex -- $p)
        if string match -rq -- $escaped $str
            return 0
        end
    end
    return 1
end
