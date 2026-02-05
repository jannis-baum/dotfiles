#!/bin/zsh

if [[ $# -lt 2 ]]; then
    echo "usage: $0 duration title [title ...] " >&2
    exit 1
fi

duration="$1"
shift
title="$@"

seconds="$(sed -nE \
    -e 's/^([[:digit:]]+)s?$/\1/p' \
    -e 's/^([[:digit:]]+)m$/\1 * 60/p' \
    -e 's/^([[:digit:]]+)(m|:)([[:digit:]]+)s?$/\1 * 60 + \3/p' \
    -e 's/^([[:digit:]]+)h$/\1 * 3600/p' \
    -e 's/^([[:digit:]]+)h([[:digit:]]+)m$/\1 * 3600 + \2 * 60/p' \
    -e 's/^([[:digit:]]+)(h|:)([[:digit:]]+)(m|:)?([[:digit:]]+)s?$/\1 * 3600 + \3 * 60 + \5/p' \
    <<< "$duration")"

if [[ -z "$seconds" ]]; then
    echo "duration not understood \"$duration\"" >&2
    exit 1
fi

deadline="$(echo "$(date +%s) + $seconds" | bc)"

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
