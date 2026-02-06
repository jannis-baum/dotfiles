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
    if [[ "$time_left" -ge 3600 ]]; then
        time_left="$(gdate -u -d "@$time_left" "+%-H:%Mh")"
    elif [[ "$time_left" -ge 60 ]]; then
        time_left="$(gdate -u -d "@$time_left" "+%-M:%Smin")"
    else
        time_left="${time_left}s"
    fi
    sketchybar --set "$NAME" label="􀐱 $title: $time_left"
else
    sketchybar --set "$NAME" label="􁙜 $title" label.color=0xfffc897e
fi
