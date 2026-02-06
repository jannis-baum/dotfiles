alias c="printf '\n%.0s' {2..$LINES} && clear"
alias w='printf "%s" "$(VISUAL=nvim vipe)" | pbcopy'
alias ssh='kitty +kitten ssh'
alias g='gsi'
alias stitch-jpegs="cat *.jpeg | ffmpeg -f image2pipe -vcodec mjpeg -i - -vcodec libx264 out.mp4"
alias screenshot='screencapture -i'
alias drag=~/Applications/drag.app/Contents/MacOS/drag
alias q="cd; c"
alias td=todos
alias timer="~/.config/sketchybar/scripts/set-timer.zsh"
