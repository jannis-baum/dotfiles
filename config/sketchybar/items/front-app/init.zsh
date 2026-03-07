item_dir="${0:a:h}"

sketchybar --add item front_app left \
           --set front_app \
                script="$item_dir/script" \
           --subscribe front_app front_app_switched tabs_updated
