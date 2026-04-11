function clip --description 'Copy file contents or stdin to Wayland clipboard'
    if not isatty stdin
        # Piped input
        if test (count $argv) -eq 0
            wl-copy
        else
            wl-copy -t $argv[1]
        end
        echo "Copied stdin to clipboard"
        return 0
    end
    
    if test (count $argv) -eq 0
        echo "Usage: clip <file>"
        echo "       command | clip [mime-type]"
        return 1
    end
    
    if not test -f $argv[1]
        echo "Error: '$argv[1]' is not a file"
        return 1
    end
    
    set -l mime (file --mime-type -b $argv[1])
    wl-copy -t $mime < $argv[1]
    echo "Copied '$argv[1]' ($mime) to clipboard"
end
