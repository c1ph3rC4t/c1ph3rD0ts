set -l motd_file (find /etc/motd.d/ -type f 2>/dev/null | shuf -n 1)
test -n "$motd_file"; and cat $motd_file
