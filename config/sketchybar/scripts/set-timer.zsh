#!/bin/zsh

if [[ $# -lt 2 ]]; then
    echo "usage: $0 n_seconds title [title ...] " >&2
    exit 1
fi

deadline="$(echo "$(date +%s) + $1" | bc)"
shift
title="$@"

timer_dir="$HOME/.local/state/sketchybar/timers/"
mkdir -p "$timer_dir"

id="$(uuidgen)"
data_fp="$timer_dir/$id"

cat <<EOF > "$data_fp"
deadline="$deadline"
title="$title"
EOF

name="TIMER_$id"
sketchybar --add item "$name" right \
           --set "$name" \
               update_freq=1 \
               script="~/.config/sketchybar/plugins/timer.zsh" \
               click_script="sketchybar --remove $name; rm $data_fp" \
           --update
