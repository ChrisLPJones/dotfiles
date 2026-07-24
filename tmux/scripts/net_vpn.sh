#!/usr/bin/env bash

parts=()
for iface in $(ip -o link show | awk -F': ' '{print $2}' | grep -E '^(tun|wg)[0-9]'); do
    ip=$(ip -4 addr show "$iface" 2>/dev/null | awk '/inet / {print $2}' | cut -d/ -f1 | head -1)
    [[ -n "$ip" ]] && parts+=("$iface: $ip")
done

if [[ ${#parts[@]} -gt 0 ]]; then
    joined=$(printf ' | %s' "${parts[@]}")
    echo " ${joined:3}"
fi
