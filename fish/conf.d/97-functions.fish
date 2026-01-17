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

# CL
function cl
    set -f recogext rs tsx jsx ts js css html cpp c h hpp py go java kt swift rb php cs lua sh bash fish sql json yaml yml toml cfg md vue svelte scss sass less zig ex exs hs
    set -f pure false
    set -f debug false

    if test (count $argv) -eq 0
        echo "cl: missing operand"
        echo "Try 'cl --help' for more information on how to use CL."
        return 1
    else if test "$argv[1]" = "--help"
        echo "Usage: cl [FLAG OR CATEGORY OR FILE EXTENSION]..."
        echo "Counts the total non-empty lines of all files relevant to any CATEGORY or FILE EXTENSION"
        echo "If an argument is not recognized by CL it will prompt the user for confirmation on whether or not to use it as a file extension."
        echo ""
        echo "Flags:"
        echo "  -h, --hidden              Include hidden directories and files in the search."
        echo "  -p, --pure                Only output the number and nothing else, handy for pipeing output."
        echo "  -D, --debug               For debugging the command generated and ran by CL."
        echo "  -d#                       Sets search depth to #."
        echo ""
        echo "Recognized categories:"
        echo "  web/webdev    | tsx,jsx,ts,js,css,html"
        echo "  rust          | rs                    "
        echo "  react         | tsx,jsx               "
        echo "  typescript    | tsx,ts                "
        echo "  javascript    | jsx,js                "
        echo "  cplusplus/c++ | cpp,hpp,c,h           "
        echo "  python        | py                    "
        echo "  golang        | go                    "
        echo "  kotlin        | kt                    "
        echo "  ruby          | rb                    "
        echo "  csharp/c#     | cs                    "
        echo "  shell         | sh,bash,fish          "
        echo "  elixir        | ex,exs                "
        echo "  styles        | css,scss,sass,less,cfg"
        echo "  config        | json,yaml,yml,toml    "
        echo "  markup        | html,md               "
        echo ""
        echo "Recognized file extensions:"
        for ext in $recogext
            echo "  .$ext"
        end
        echo ""
    else
        # Parse flags
        for arg in $argv
            if contains_any $arg $flags
                echo "cl: Flag repeated illegally."
                echo "Try 'cl --help' for more information on how to use CL."
                return 1
            else
                switch $arg
                    case '-*'
                        switch $arg
                            case -h --hidden
                                set -f args "$args --hidden"
                                set -a flags -h
                            case -p --pure
                                set -f pure true
                            case -D --debug
                                set -f debug true
                                set -a flags -D
                            case "-d*"
                                set -f args "$args -d $(string sub -s 3 -- $arg)"
                                set -a flags -d
                            case '*'
                                echo "cl: unrecognized flag $arg"
                                echo "Try 'cl --help' for more information on how to use CL."
                                return 1
                        end
                end
            end
        end

        # Parse categories and extensions
        for arg in $argv
            set -l larg (string lower -- $arg)
            switch $larg
                case web webdev
                    set -f args "$args -e tsx -e jsx -e ts -e js -e css -e html"
                case rust
                    set -f args "$args -e rs"
                case react
                    set -f args "$args -e tsx -e jsx"
                case typescript
                    set -f args "$args -e tsx -e ts"
                case javascript
                    set -f args "$args -e jsx -e js"
                case css
                    set -f args "$args -e css"
                case html
                    set -f args "$args -e html"
                case cplusplus c++
                    set -f args "$args -e cpp -e hpp -e c -e h"
                case python
                    set -f args "$args -e py"
                case golang
                    set -f args "$args -e go"
                case kotlin
                    set -f args "$args -e kt"
                case ruby
                    set -f args "$args -e rb"
                case csharp c#
                    set -f args "$args -e cs"
                case shell
                    set -f args "$args -e sh -e bash -e fish"
                case elixir
                    set -f args "$args -e ex -e exs"
                case styles
                    set -f args "$args -e css -e scss -e sass -e less"
                case config
                    set -f args "$args -e json -e yaml -e yml -e toml -e cfg"
                case markup
                    set -f args "$args -e html -e md"
                case markdown
                    set -f args "$args -e md"
                case '-*'
                    true
                case '*'
                    if contains -- $larg $recogext
                        set -f args "$args -e $larg"
                    else
                        read -l -P "Unrecognized filetype or category \"$arg\", use as file extension?(Y/n) " confirm
                        set -l confirm (string lower -- $confirm)
                        if test $confirm != n; and test $confirm != no
                            set -f args "$args -e $larg"
                        end
                    end
            end
        end

        if string match -rq -- '-e' "$args"
            if $pure
                set -f cmd "fd$args -x cat {} | sed '/^\\s*\$/d' | wc -l"
                eval $cmd
            else
                if ! $debug
                    echo "Welcome to CL(Code Lines) a script by c1ph3rC4t"
                end
                set -f cmd "fd$args -x cat {} | sed '/^\\s*\$/d' | wc -l"
                if $debug
                    echo $cmd
                else
                    echo "Line count: $(eval $cmd)"
                end
            end
        else
            echo "cl: no categories nor file extensions found"
            echo "Try 'cl --help' for more information on how to use CL."
            return 1
        end
    end
end
