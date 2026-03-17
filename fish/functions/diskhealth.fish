function diskhealth
    for disk in (lsblk -d -o PATH | grep -iE "/dev/sd|/dev/nvme")
        echo "=== $disk ==="
        sudo smartctl -H $disk
    end
end
