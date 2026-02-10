#!/bin/zsh

# appear when CPU usage goes above threshold, mostly to detect stuck busy
# processes

# ps:
#   -A for all user processes
#   -r to sort by CPU
#   -o is format
#   comm is command
# head/tail to get max cpu & remove header
# xargs to trim whitespace
ps_out="$(ps -Aro %cpu,comm | head -2 | tail -1 | xargs)"
cpu="$(cut -w -f1 <<<"$ps_out")"

if [[ "$cpu" -lt 90 ]]; then
    sketchybar --set "$NAME" drawing=off
    exit 0
fi

# get process executable name at end of path
proc="$(cut -w -f2- <<< "$ps_out" | sed -E 's|.*/([^/]*)$|\1|')"

sketchybar --set "$NAME" drawing=on label="$proc"
