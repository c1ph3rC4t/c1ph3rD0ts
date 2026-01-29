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

# YT-DLP REPL
function yt_repl
    while true
        echo ""
        read -f -P "[yt-dlp repl]# " input
        if test "$input" = "q"
            break
        end
        set -f input (string replace -ra -- "'" "" $input)
        yt-dlp -f best "$input"
    end
end

# GnuPG
function gpg_repl
    clear

    if test (count $argv) -gt 0
        set -f recipient $argv
    else
        gpg --list-keys
        read -f -P "Who is the recipient? " recipient
    end

    clear
    
    while true
        if ! test $recipient = ""
            echo -e "\x1b[34m[you]\x1b[0m >==< \x1b[34m[$recipient]\x1b[0m"
        end
        read -f -P "[gpg]# " input
        switch $input
            case ""
                break
            case "c"
                clear
            case "e"
                echo -e -- "\x1b[34m[you]\x1b[0m >==> \x1b[34m\x1b[1m[$recipient]\x1b[0m"
                read -f -P "[msg]# " input
                echo -- $input | gpg -ea -r $recipient
            case "d"
                echo -e -- "\x1b[34m\x1b[1m[you]\x1b[0m <==< \x1b[34m[$recipient]\x1b[0m"
                read -f -P "[msg]# " input
                echo -- $input | gpg -d
            case "i"
                read -f -P "[imp]# " input
                echo -- $input | gpg --import
            case "r"
                gpg --list-keys
                read -f -P "Who is the new recipient? " recipient
        end
    end
end
