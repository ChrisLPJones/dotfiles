#!/usr/bin/env bash

# Primary interface (one used for default route)
primary=$(ip route get 8.8.8.8 2>/dev/null | awk '/dev/ {for(i=1;i<=NF;i++) if($i=="dev") print $(i+1)}')
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
