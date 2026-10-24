#!/usr/bin/env bash

# Default route device, skipping VPN tunnels (a full-tunnel VPN takes over the
# default route, which would otherwise make the "primary" IP the VPN's IP)
iface=$(ip -4 route show default 2>/dev/null | awk '{for(i=1;i<=NF;i++) if($i=="dev") print $(i+1)}' | grep -vE '^(tun|wg)[0-9]' | head -1)
ip=$(ip -4 addr show "$iface" 2>/dev/null | awk '/inet / {print $2}' | cut -d/ -f1 | head -1)

[[ -n "$iface" && -n "$ip" ]] && echo " $iface: $ip"
