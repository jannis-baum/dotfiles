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
# time left is difference between deadline and now or pausing timestamp
time_left="$(( $deadline - $( [[ -v paused ]] && printf "$paused" || date +%s) ))"

case "$SENDER" in
    # scheduled script
    "routine" | "forced")
        if [[ "$time_left" -gt 0 ]]; then
            # time formatting
            if [[ "$time_left" -ge 3600 ]]; then
                time_left="$(gdate -u -d "@$time_left" "+%-H:%Mh")"
            elif [[ "$time_left" -ge 600 ]]; then
                time_left="$(gdate -u -d "@$time_left" "+%-Mmin")"
            elif [[ "$time_left" -ge 60 ]]; then
                time_left="$(gdate -u -d "@$time_left" "+%-M:%Smin")"
            else
                time_left="${time_left}s"
            fi
            # paused color
            [[ -v paused ]] && label_color="0xff808080" || label_color="0xffbbbbbb"
            sketchybar --set "$NAME" label="􀐱 $title: $time_left" label.color="$label_color"
        else
            sketchybar --set "$NAME" label="􁙜 $title" label.color=0xfffc897e
        fi
        ;;

    # click script
    "mouse.clicked")
        case "$BUTTON" in
            "left")
                if [[ -v paused ]]; then
                    # clear pausing data & shift deadline by time timer was paused
                    updated_data="$(cat "$data_fp" | grep -ve paused -e deadline)"
                    new_deadline="$(( $(date +%s) - $paused + $deadline ))"
                    echo "$updated_data\ndeadline=$new_deadline" > "$data_fp"
                else
                    echo "paused=$(date +%s)" >> "$data_fp"
                fi
                ;;
            "right")
                [[ "$time_left" -le 0 && -x "$after_done" ]] && "$after_done"
                remove_self
                exit
                ;;
        esac
        sketchybar --update
        ;;
esac
