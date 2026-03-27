#!/usr/bin/bash

# Clear
STATUS=""

# Warp
WARP_STATUS=$(warp-cli status 2>&1)

STATUS_UPDATE=$(echo "$WARP_STATUS" | grep -iE 'status update' | awk -F ': ' '{print $2}')
SUB_STATUS=$(echo "$WARP_STATUS" | grep -iE 'network|reason' | awk -F ': Performing happy eyeballs to |: ' '{print $2}')
DAEMON_UNRESPONSIVE=$(echo "$WARP_STATUS" | grep -qiE "Unable to connect to the CloudflareWARP daemon" && echo "Daemon disconnect.")

[ -n "$STATUS_UPDATE" ] && STATUS+=$(
    echo "WARP: ${STATUS_UPDATE^}"
    [ -n "$SUB_STATUS" ] && echo " (${SUB_STATUS^})"
)
STATUS+=$DAEMON_UNRESPONSIVE

# Tailscale
TAILSCALE_UPDATE=$(tailscale status --json)

TAILSCALE_IS_ONLINE=$([ "$(echo "$TAILSCALE_UPDATE" | jq -r ".Self.Online")" == "true" ] && echo Online || echo Offline)
TAILSCALE_NODES_ONLINE=$(echo "$TAILSCALE_UPDATE" | jq ".Peer.[].Online" | grep -iE "true" | wc -l || 0)
((TAILSCALE_NODES_ONLINE++))

[ -n "$TAILSCALE_IS_ONLINE" ] && STATUS+=$(
    [ -n "$STATUS" ] && echo " | "
    echo "Tailscale: ${TAILSCALE_IS_ONLINE^}"
    [ $TAILSCALE_NODES_ONLINE -ge 2 ] && echo " (${TAILSCALE_NODES_ONLINE^} nodes)"
)

# Print
echo ${STATUS:-No VPN}
