#!/bin/zsh

# set up dimensions for font ---------------------------------------------------
sketchy_dir="$HOME/.config/sketchybar"
output_file="$HOME/.local/state/sketchybar/widths.txt"
mkdir -p "$(dirname "$output_file")"

app="$(osascript -l JavaScript -e 'ObjC.import("AppKit");$.NSWorkspace.sharedWorkspace.frontmostApplication.localizedName')"

function set_tabs() {
    luajit "$sketchy_dir/scripts/set-sketchytabs.lua" "$app"
}

function get_width() {
    sketchybar --query "APP-$app-$1" | jq '.bounding_rects."display-1".size[0]'
}

# pretend everything has 0 width so we get no ellipising in test
echo "base:0\nchar:0\nimage:0" > "$output_file"
# prepare long title so we can get good estimate of char width (sketchybar
# reports integer width for item)
long_title_len=50
long_title="$(cat /dev/urandom | base64 | head -c $long_title_len)"


echo "::a\n::$long_title\n:$sketchy_dir/media/placeholder-icon.png:a" | set_tabs
item_1_char=$(get_width 1)
item_long_chars=$(get_width 2)
item_1_char_icon=$(get_width 3)
echo '' | set_tabs

char_w=$(bc <<< "scale=5; ($item_long_chars - $item_1_char) / ($long_title_len - 1)")
image_w=$(bc <<< "$item_1_char_icon - $item_1_char")
base_w=$(bc <<< "$item_1_char - $char_w")

echo "base:$base_w\nchar:$char_w\nimage:$image_w" > "$output_file"

# set up icon RAM disk ---------------------------------------------------------

# exit if volume is already there
test -d /Volumes/sketchytabs && exit 0

# create ram disk with given number of 512byte blocks (i.e. 256MB)
diskutil erasevolume APFS "sketchytabs" $(hdiutil attach -nomount ram://524288)
