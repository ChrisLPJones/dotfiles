#!/usr/bin/env bash

# Primary interface (default route device, skipping VPN tunnels - a full-tunnel
# VPN takes over the default route and would otherwise be reported as primary)
primary=$(ip -4 route show default 2>/dev/null | awk '{for(i=1;i<=NF;i++) if($i=="dev") print $(i+1)}' | grep -vE '^(tun|wg)[0-9]' | head -1)
primary_ip=$(ip -4 addr show "$primary" 2>/dev/null | awk '/inet / {print $2}' | cut -d/ -f1 | head -1)

parts=()
[[ -n "$primary" && -n "$primary_ip" ]] && parts+=("$primary: $primary_ip")

# VPN interfaces (tun*, wg*)
for iface in $(ip -o link show | awk -F': ' '{print $2}' | grep -E '^(tun|wg)[0-9]'); do
    vpn_ip=$(ip -4 addr show "$iface" 2>/dev/null | awk '/inet / {print $2}' | cut -d/ -f1 | head -1)
    [[ -n "$vpn_ip" ]] && parts+=("$iface: $vpn_ip")
done

joined=$(printf ' | %s' "${parts[@]}")
echo " ${joined:3}"
