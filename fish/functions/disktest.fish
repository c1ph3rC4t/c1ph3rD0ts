function disktest
    set disks (lsblk -d -o PATH | grep -iE "/dev/sd|/dev/nvme")
    
    switch $argv[1]
        case short long
            for disk in $disks
                echo -e "\x1b[1m\x1b[34m::\x1b[0m\x1b[1m $disk\x1b[0m"
                sudo smartctl -t $argv[1] $disk
            end
        case status
            for disk in $disks
                echo -e "\x1b[1m\x1b[34m::\x1b[0m\x1b[1m $disk\x1b[0m"
                sudo smartctl -H -l selftest $disk
            end
        case '*'
            echo "Usage: disktest [short|long|status]"
    end
end
