#!/bin/zsh

function get_busy_processes() {
    n_samples=5
    cpu_thresh=90

    # get all processes with cpu usage > cpu_thresh for n_samples
    for _ in {1..$n_samples}; do
        # ps -A all user processes, -o output cpu usage % and command path
        # awk filter for cpu > cpu_thresh, then print only command path
        ps -Ao %cpu,pid,comm \
            | awk '$1 > '$cpu_thresh' { $1=""; sub(/^ /,""); print }'
        sleep 1
    done \
        | sort | uniq -c \
        | awk '$1 == '$n_samples' { $1=""; sub(/^ /,""); print }'
    # sort to group same lines, uniq -c counts consecutive same lines
    # awk filters for lines that occurred in every sample, then removes counts
}

source "$CONFIG_DIR/helpers/hover.zsh"
sketchy_args=(--set "$NAME")

if [[ "$SENDER" == "routine" || "$SENDER" == "forced" ]]; then
    procs="$(get_busy_processes)"
    [[ -n "$procs" ]] \
        && sketchy_args+=(drawing=on) \
        || sketchy_args+=(drawing=off popup.drawing=off)

    # clear cpu busy popup items
    sketchy_args+=(--remove '/CPU_BUSY-\d*/')

    # add item for each process
    for proc in ${(f)procs}; do
        pid="$(cut -w -f1 <<< "$proc")"
        item_name="CPU_BUSY-$pid"

        proc_name="$(cut -w -f2- <<< "$proc" | sed -E 's|.*/([^/]*)$|\1|')"
        label="$proc_name ($pid)"

        sketchy_args+=(
            --add item "$item_name" "popup.$NAME"
            --set "$item_name" label="$label" label.color=0xfffc897e
        )
    done
else
    $HOVERING \
        && sketchy_args+=(popup.drawing=on) \
        || sketchy_args+=(popup.drawing=off)
fi

sketchybar "${sketchy_args[@]}"
