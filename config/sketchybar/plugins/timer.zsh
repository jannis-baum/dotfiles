#!/bin/zsh

echo "name: $NAME, sender: $SENDER"

# extract ID, exit if not existing
id="$(sed -nE 's/^TIMER_([[:alnum:]-]+)$/\1/p' <<< "$NAME")"
[[ -z "$id" ]] && exit 1

# corresponding data & after done script files
data_fp="$HOME/.local/state/sketchybar/timers/$id"
after_done="$data_fp.after_done"
# cleanup function
function remove_self() {
    sketchybar --remove "$NAME"
    rm -f "$data_fp" "$after_done"
}

# source data file; exit and remove item if not existing; compute time left
if ! [[ -f "$data_fp" ]]; then
    remove_self
    exit 1
fi
source "$data_fp"
time_left="$(echo "$deadline - $(date +%s)" | bc)"

case "$SENDER" in
    # scheduled script
    "routine" | "forced")
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
        ;;

    # click script
    "mouse.clicked")
        [[ "$BUTTON" == right ]] || exit
        [[ "$time_left" -le 0 && -x "$after_done" ]] && "$after_done"
        remove_self
        exit
        ;;
esac
