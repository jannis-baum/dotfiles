#!/bin/zsh

# extract ID, exit if not existing
id="$(sed -nE 's/^TIMER_([[:alnum:]-]+)$/\1/p' <<< "$NAME")"
[[ -z "$id" ]] && exit 1

# source corresponding data file, exit and remove item if not existing
data_fp="$HOME/.local/state/sketchybar/timers/$id"
if ! [[ -f "$data_fp" ]]; then
    sketchybar --remove "$NAME"
    exit 1
fi
source "$data_fp"

time_left="$(echo "$deadline - $(date +%s)" | bc)"

if [[ "$time_left" -gt 0 ]]; then
    sketchybar --set "$NAME" label="􀐱 $title: ${time_left}s"
else
    sketchybar --set "$NAME" label="􁙜 $title" label.color=0xfffc897e
fi
