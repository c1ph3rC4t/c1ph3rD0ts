function randport
    while true
        set port (random 49152 65535)
        if not ss -tuln | grep -q ":$port "
            echo $port
            return
        end
    end
end
