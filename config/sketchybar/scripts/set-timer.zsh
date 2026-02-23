#!/bin/zsh

script_path="$0"

function set_timer() {
    local seconds="$1"
    local title="$2"

    local timer_dir="$HOME/.local/state/sketchybar/timers/"
    mkdir -p "$timer_dir"

    local deadline="$(echo "$(date +%s) + $seconds" | bc)"
    local id="$(uuidgen)"
    local data_fp="$timer_dir/$id"

    cat <<EOF > "$data_fp"
deadline="$deadline"
title="$title"
EOF

    # if stdin is not a terminal read script to run after time is done (and
    # then dismissed) from there
    if ! [[ -t 0 ]]; then
        local after_done="$data_fp.after_done"
        cat > "$after_done"
        chmod +x "$after_done"
    fi

    local name="TIMER_$id"
    sketchybar --add item "$name" right \
               --set "$name" \
                   update_freq=1 \
                   script="~/.config/sketchybar/plugins/timer.zsh" \
               --subscribe "$name" mouse.clicked \
               --update
}

function cli() {
    if [[ $# -lt 2 ]]; then
        echo "usage: $script_path duration title [title ...] " >&2
        exit 1
    fi

    duration="$1"
    shift
    title="$@"

    digits="([[:digit:]]+)"
    sed_args=(
        # no printing by default & extended regex
        -nE
        # just seconds/minutes/hours
        -e "s/^${digits}s?$/\\1/p"
        -e "s/^${digits}(m|min)$/\\1 * 60/p"
        -e "s/^${digits}h$/\\1 * 3600/p"
        # minutes and seconds 2:30(m|min)? or 2(m|min)30s
        -e "s/^${digits}:${digits}(m|min)?$/\\1 * 60 + \\2/p"
        -e "s/^${digits}(m|min)${digits}s$/\\1 * 60 + \\3/p"
        # hours and minutes 2:30h or 2h30(m|min)
        -e "s/^${digits}:${digits}h$/\\1 * 3600 + \\2 * 60/p"
        -e "s/^${digits}h${digits}(m|min)$/\\1 * 3600 + \\2 * 60/p"
        # hours, minutes and seconds 2:30:40h or 2h30(m|min)40s
        -e "s/^${digits}:${digits}:${digits}h$/\\1 * 3600 + \\2 * 60 + \\3/p"
        -e "s/^${digits}h${digits}(m|min)${digits}s$/\\1 * 3600 + \\2 * 60 + \\4/p"
    )
    seconds="$(sed "${sed_args[@]}" <<< "$duration")"

    if [[ -z "$seconds" ]]; then
        echo "duration not understood \"$duration\"" >&2
        exit 1
    fi

    set_timer "$seconds" "$title"
}

function cli_tomato() {
    # <-> matches integers
    [[ "$1" == <-> ]] \
        && local phase="$1" \
        || local phase="0"

    # 8 phases: [work, short break] * 3 + [work, long break]
    local mod_phase="$(( "$phase" % 8 ))"

    case "$mod_phase" in
        # work
        0 | 2 | 4 | 6)
            local title="tomato $(( "$phase" / 2 + 1))"
            local seconds="1500"
            ;;
        # short break
        1 | 3 | 5)
            local title="break"
            local seconds="300"
            ;;
        # long break
        7)
            local title="break"
            local seconds="1800"
            ;;
    esac

    echo '#!/bin/zsh'"\n$script_path --tomato $(( "$phase" + 1 ))" \
        | set_timer "$seconds" "$title"
}

if [[ "$1" == "--tomato" || "$1" == "-t" ]]; then
    shift
    cli_tomato $@
else
    cli $@
fi
