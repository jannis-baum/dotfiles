item_dir="${0:a:h}"

# invisible button that covers all empty space to hide briefly and show vanilla
# menubar (added first to be in background)
sketchybar --add item hide-button right \
           --set hide-button \
               width=9999 \
               click_script="$item_dir/click"
