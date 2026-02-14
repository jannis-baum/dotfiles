state_file="$HOME/.local/state/sketchybar/hover/$NAME"
mkdir -p "$(dirname "$state_file")"

case "$SENDER" in
  "mouse.entered") echo "true" > "$state_file";;
  "mouse.exited") echo "false" > "$state_file";;
esac

state="$(cat "$state_file")"
[[ "$state" == "true" ]] \
    && HOVERING=true \
    || HOVERING=false
