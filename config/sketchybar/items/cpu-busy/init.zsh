item_dir="${0:a:h}"

sketchybar --add item cpu_busy right \
           --set cpu_busy \
               "$label_font_symbol" \
               "$label_color_alert" \
               update_freq=5 \
               script="$item_dir/script" \
               label="􀫥" \
               drawing=off \
           --subscribe cpu_busy mouse.entered mouse.exited
