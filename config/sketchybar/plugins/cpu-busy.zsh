#!/bin/zsh

# appear when CPU usage goes above threshold, mostly to detect stuck busy
# processes

source "$CONFIG_DIR/helpers/hover.zsh"

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

sketchybar --set "$NAME" drawing=on

$HOVERING \
    && label="$(cut -w -f2- <<<"$ps_out")" \
    || label="$cpu%"

sketchybar --set "$NAME" label="$label"
