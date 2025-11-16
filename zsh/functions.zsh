# File and directory navigation
mkcd() {
    if [ -z $1 ]; then
        echo -e "mkcd: missing operand\nTry 'mkcd --help' for more information."
    elif [ $1 = '--help' ]; then
        echo -e "Usage: mkcd DIRECTORY\nCreate the directory, if it does not exist and cd into it."
    else
        mkdir -p $1
        cd $1
    fi
}

# Basic short-term backup function
bak() {
    local restore=0
    local move=0
    local target=""
    
    for arg in "$@"; do
        if [ "$arg" = "--help" ]; then
            echo -e "Usage: bak [OPTION] FILE/DIRECTORY\nBack up or restore files and directories.\n\n  -r FILE.bak       restore FILE.bak to FILE (removes .bak extension)\n  -R                move instead of copy\n      --help        display this help and exit\n\nCreates a copy of FILE as FILE.bak or DIRECTORY as DIRECTORY.bak.\nUse -r to restore a backup by removing the .bak extension.\nUse -R to move instead of copy."
            return
        elif [ "$arg" = "-r" ]; then
            restore=1
        elif [ "$arg" = "-R" ]; then
            move=1
        else
            target="$arg"
        fi
    done
    
    if [ -z "$target" ]; then
        echo -e "bak: missing operand\nTry 'bak --help' for more information."
        return
    fi
    
    if [ $restore -eq 1 ]; then
        if [[ "$target" == *.bak ]]; then
            if [ ! -e "$target" ]; then
                echo "bak: cannot stat '$target': No such file or directory"
                return 1
            fi
            if [ $move -eq 1 ]; then
                mv "$target" "${target%.bak}"
            else
                cp -r "$target" "${target%.bak}"
            fi
        else
            if [ ! -e "$target.bak" ]; then
                echo "bak: cannot stat '$target.bak': No such file or directory"
                return 1
            fi
            if [ $move -eq 1 ]; then
                mv "$target.bak" "$target"
            else
                cp -r "$target.bak" "$target"
            fi
        fi
    else
        if [ ! -e "$target" ]; then
            echo "bak: cannot stat '$target': No such file or directory"
            return 1
        fi
        if [ $move -eq 1 ]; then
            mv "$target" "$target.bak"
        else
            cp -r "$target" "$target.bak"
        fi
    fi
}
