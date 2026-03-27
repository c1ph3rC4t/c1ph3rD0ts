#!/usr/bin/bash

# Clear
STATUS=""

# Warp
STATUS_UPDATE=$(warp-cli status | grep -iE 'status update' | awk -F ': ' '{print $2}')
NETWORK_STATUS=$(warp-cli status | grep -iE 'network' | awk -F ': ' '{print $2}')
DAEMON_UNRESPONSIVE=$(warp-cli status 2>&1 | grep -qiE "Unable to connect to the CloudflareWARP daemon" && echo "Daemon disconnect.")

[ -n "$STATUS_UPDATE" ] && STATUS+=$(
    echo "WARP: ${STATUS_UPDATE^}"
    [ -n "$NETWORK_STATUS" ] && echo " (${NETWORK_STATUS^})"
)
STATUS+=$DAEMON_UNRESPONSIVE

# Tailscale
TAILSCALE_IS_ONLINE=$([ "$(tailscale status --json | jq -r ".Self.Online")" == "true" ] && echo Online || echo Offline)
TAILSCALE_NODES_ONLINE=$(tailscale status --json | jq ".Peer.[].Online" | grep -iE "true" | wc -l || 0)
((TAILSCALE_NODES_ONLINE++))

[ -n "$TAILSCALE_IS_ONLINE" ] && STATUS+=$(
    [ -n "$STATUS" ] && echo " | "
    echo "Tailscale: ${TAILSCALE_IS_ONLINE^}"
    [ $TAILSCALE_NODES_ONLINE -ge 2 ] && echo " (${TAILSCALE_NODES_ONLINE^} nodes)"
)

# Print
echo ${STATUS:-No VPN}
