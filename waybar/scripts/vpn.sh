#!/usr/bin/bash

# Clear
STATUS=""

# Warp
BUF=$(warp-cli status | grep -iE 'network' | awk -F ' ' '{print $2}')
[ -n "$BUF" ] && STATUS+="WARP: ${BUF^}"

# Print
echo ${STATUS:-No VPN}
