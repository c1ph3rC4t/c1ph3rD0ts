# Basic short-term backup function
function bak
    set restore 0
    set move 0
    set target ""

    for arg in $argv
        if test "$arg" = "--help"
            echo "Usage: bak [OPTION] FILE/DIRECTORY"
            echo "Back up or restore files and directories."
            echo
            echo "  -r FILE.bak       restore FILE.bak to FILE (removes .bak extension)"
            echo "  -R                move instead of copy"
            echo "      --help        display this help and exit"
            echo
            echo "Creates a copy of FILE as FILE.bak or DIRECTORY as DIRECTORY.bak."
            echo "Use -r to restore a backup by removing the .bak extension."
            echo "Use -R to move instead of copy."
            return
        else if test "$arg" = "-r"
            set restore 1
        else if test "$arg" = "-R"
            set move 1
        else
            set target "$arg"
        end
    end

    if test -z "$target"
        echo "bak: missing operand"
        echo "Try 'bak --help' for more information."
        return
    end

    if test $restore -eq 1
        if string match -qr '\.bak$' "$target"
            if not test -e "$target"
                echo "bak: cannot stat '$target': No such file or directory"
                return 1
            end

            set newname (string replace -r '\.bak$' '' "$target")

            if test $move -eq 1
                mv "$target" "$newname"
            else
                cp -r "$target" "$newname"
            end
        else
            if not test -e "$target.bak"
                echo "bak: cannot stat '$target.bak': No such file or directory"
                return 1
            end

            if test $move -eq 1
                mv "$target.bak" "$target"
            else
                cp -r "$target.bak" "$target"
            end
        end
    else
        if not test -e "$target"
            echo "bak: cannot stat '$target': No such file or directory"
            return 1
        end

        if test $move -eq 1
            mv "$target" "$target.bak"
        else
            cp -r "$target" "$target.bak"
        end
    end
end
