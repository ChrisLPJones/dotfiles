#!/usr/bin/env bash
# Toggle a tmux user option between 0/1, e.g. toggle_status_module.sh @net_ip_visible
# Also persists all status-module toggle states to disk (outside the dotfiles
# repo - local to this machine) so they survive closing/restarting tmux.

opt="$1"
current=$(tmux show-options -gv "$opt" 2>/dev/null)
[[ "$current" == "0" ]] && new=1 || new=0
tmux set-option -g "$opt" "$new"
tmux refresh-client -S

state_file="$HOME/.tmux/status_modules.conf"
mkdir -p "$(dirname "$state_file")"
{
	for o in @net_ip_visible @battery_visible @cpu_visible @ram_visible @gpu_visible @directory_visible; do
		v=$(tmux show-options -gv "$o" 2>/dev/null)
		printf 'set -g %s "%s"\n' "$o" "${v:-0}"
	done
} >"$state_file"
