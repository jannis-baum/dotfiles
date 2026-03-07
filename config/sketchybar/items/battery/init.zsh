item_dir="${0:a:h}"

sketchybar --add item battery right \
               --set battery \
                   "$label_font_numbers" \
                   update_freq=10 \
                   script="$item_dir/scripts/main" \
               --subscribe battery mouse.entered mouse.exited power_source_change \
           --add item battery-percentage popup.battery \
               --set battery-percentage \
                   update_freq=10 \
                   script="$item_dir/scripts/percentage" \
               --subscribe battery-percentage power_source_change
