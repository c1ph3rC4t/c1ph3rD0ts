# Pray
function npm
    if test "$argv[1]" = "pray"
        set args $argv
        set args (string sub -s 2 $args)
        command npm install $args
    else
        command npm $argv
    end
end
