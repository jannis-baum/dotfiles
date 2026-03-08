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

        local title="$(jq -r .payload.title <<< "$line")"
        local artist="$(jq -r .payload.artist <<< "$line")"
        local app="$(jq -r .payload.bundleIdentifier <<< "$line")"
        sketchybar --set now-playing \
                        drawing=on \
                        label="$(_ellipsize 24 "$title - $artist")" \
                        label.color="$label_color" \
                  --set now-playing-title label="􀋷 $title" \
                  --set now-playing-artist label="􂃓 $artist" \
                  --set now-playing-app label="􀑋 $app"
    done
}

function _watch_media() {
    media-control stream --no-diff | _update
}

sketchybar --add item now-playing right \
           --set now-playing \
               drawing=off \
               script="$item_dir/script" \
               click_script="$item_dir/click" \
           --subscribe now-playing mouse.entered mouse.exited \
           --add item now-playing-title popup.now-playing \
           --add item now-playing-artist popup.now-playing \
           --add item now-playing-app popup.now-playing

_watch_media &!
_monitor_sketchybar $! &!
