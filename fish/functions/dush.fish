function dush
    du -sh $argv 2>/dev/null | while read -l size path
        set -l n (string replace -ra '[^0-9.]' '' $size)
        set -l unit (string replace -ra '[0-9.]' '' $size)
        switch $unit
            case K; set n (math -s0 "$n * 1024")
            case M; set n (math -s0 "$n * 1024^2")
            case G; set n (math -s0 "$n * 1024^3")
            case T; set n (math -s0 "$n * 1024^4")
            case '*'; set n (math -s0 "$n")  # bare bytes
        end
        
        set -l c 32
        if test $n -gt 1073741824          # >1G
            set c 31
        else if test $n -gt 104857600      # >100M
            set c 33
        end
        printf '\x1b[%sm%s\x1b[0m\t%s\n' $c $size $path
    end
end
