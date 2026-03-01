function clip --description 'Copy file contents to Wayland clipboard'
    if test (count $argv) -eq 0
        echo "Usage: clip <file>"
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
