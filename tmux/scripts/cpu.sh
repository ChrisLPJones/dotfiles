#!/usr/bin/env bash

read -r total1 idle1 < <(awk '/^cpu / {t=0; for(i=2;i<=NF;i++) t+=$i; print t, $5}' /proc/stat)
sleep 0.3
read -r total2 idle2 < <(awk '/^cpu / {t=0; for(i=2;i<=NF;i++) t+=$i; print t, $5}' /proc/stat)

dt=$((total2 - total1))
di=$((idle2 - idle1))

[[ $dt -le 0 ]] && exit 0

usage=$(( (100 * (dt - di)) / dt ))
echo " ${usage}%"
