#!/usr/bin/env bash

for f in /sys/class/drm/card*/device/gpu_busy_percent; do
    [[ -r "$f" ]] || continue
    pct=$(cat "$f" 2>/dev/null)
    [[ -n "$pct" ]] && echo " ${pct}%" && exit 0
done
