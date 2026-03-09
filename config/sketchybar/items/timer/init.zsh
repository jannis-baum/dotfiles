item_dir="${0:a:h}"

# load existing timers analogously to `set` script
for data_fp in "$HOME/.local/state/sketchybar/timers/"*(.N); do
    local name="TIMER_$(basename "$data_fp")"
    sketchybar --add item "$name" right \
               --set "$name" \
                   update_freq=1 \
                   script="$item_dir/script" \
               --subscribe "$name" mouse.clicked \
               --update
done
