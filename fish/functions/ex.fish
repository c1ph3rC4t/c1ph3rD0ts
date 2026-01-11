# Ex
function ex
    if test (count $argv) -eq 0
        echo "ex: missing operand"
        echo "Try 'ex --help' for more information."
    else if test (count $argv) -ne 1
        echo "ex: too many operands"
        echo "Try 'ex --help' for more information."
    else if test "$argv[1]" = "--help"
        echo "Usage: ex FILE"
        echo "Make FILE executable and run it."
    else
        set path $argv[1]
        if ! string match -qr "^\.?\.?\/.+\$" -- $path
            set path "./$argv[1]"
        end

        if test -f $path
            chmod +x $path
            $path
        else
            echo "ex: file \"$path\" does not exist"
            echo "Try 'ex --help' for more information."
        end
    end
end
