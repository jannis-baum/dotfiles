item_dir="${0:a:h}"

sketchybar --add item clock right \
               --set clock \
                   "$label_font_numbers" \
                   update_freq=1 \
                   script="$item_dir/script" \
                   click_script="$item_dir/click" \
               --subscribe clock mouse.entered mouse.exited \
           --add item clock-seconds popup.clock \
               --set clock-seconds \
                   update_freq=1 \
                   script='sketchybar --set $NAME label="􀐫 $(date +%H:%M:%S | xargs)"' \
           --add item clock-date popup.clock \
               --set clock-date \
                   update_freq=60 \
                   script='sketchybar --set $NAME label="􀉉 $(date "+%a, %b %d" | xargs)"'
