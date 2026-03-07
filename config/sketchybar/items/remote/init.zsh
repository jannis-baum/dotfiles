item_dir="${0:a:h}"

sketchybar --add item remote right \
           --set remote \
               update_freq=1 \
               "$label_font_symbol" \
               "$label_color_alert" \
               script="$item_dir/script" \
               click_script="$item_dir/click"
