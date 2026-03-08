item_dir="${0:a:h}"

# if there are ever more items that need their own running process refactor
# this into sketchybarrc so it takes care of all of these processes
function _monitor_sketchybar() {
    while [[ -n "$(sketchybar --query bar)" ]]; do
        sleep 10
    done

    for proc in $@; do
        kill $proc
    done
}

function _ellipsize() {
  local max=$1
  local s=$2
  (( ${#s} > max )) && s="${s[1,max-1]}…"
  print -r -- "$s"
}

function _update() {
    while IFS= read -r line; do
        local playing="$(jq -r .payload.playing <<< "$line")"
        case "$playing" in
            "null")
                sketchybar --set now-playing drawing=off
                continue
                ;;
            "true") local label_color="0xffbbbbbb";;
            "false") local label_color="0xff808080";;
        esac

        local label="$(_ellipsize 24 "$(jq -r '"\(.payload.title) - \(.payload.artist)"' <<< "$line")")"
        sketchybar --set now-playing drawing=on label="$label" label.color="$label_color"
    done
}

function _watch_media() {
    media-control stream --no-diff | _update
}

sketchybar --add item now-playing right \
           --set now-playing \
               drawing=off

_watch_media &!
_monitor_sketchybar $! &!
