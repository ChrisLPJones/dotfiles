#!/usr/bin/env bash
# Toggle a tmux user option between 0/1, e.g. toggle_status_module.sh @net_ip_visible

opt="$1"
current=$(tmux show-options -gv "$opt" 2>/dev/null)
[[ "$current" == "0" ]] && new=1 || new=0
tmux set-option -g "$opt" "$new"
tmux refresh-client -S
