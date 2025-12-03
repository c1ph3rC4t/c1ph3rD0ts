# File and directory navigation
function mkcd
    if test (count $argv) -eq 0
        echo "mkcd: missing operand"
        echo "Try 'mkcd --help' for more information."
    else if test "$argv[1]" = "--help"
        echo "Usage: mkcd DIRECTORY"
        echo "Create the directory, if it does not exist and cd into it."
    else
        mkdir -p "$argv[1]"
        cd "$argv[1]"
    end
end
