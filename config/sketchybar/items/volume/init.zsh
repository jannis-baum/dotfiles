item_dir="${0:a:h}"

sketchybar --add item volume right \
           --set volume \
               "$label_font_symbol" \
               script="$item_dir/script" \
               click_script="$item_dir/click" \
           --subscribe volume volume_change
