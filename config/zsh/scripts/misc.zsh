# aliases
alias c="printf '\n%.0s' {2..$LINES} && clear"
alias w='printf "%s" "$(VISUAL=nvim vipe)" | pbcopy'
alias ssh='kitty +kitten ssh'
alias trm='trash'
alias g='gsi'
alias stitch-jpegs="cat *.jpeg | ffmpeg -f image2pipe -vcodec mjpeg -i - -vcodec libx264 out.mp4"
alias screenshot='screencapture -i'
alias drag=~/Applications/drag.app/Contents/MacOS/drag
alias q="cd; c"

function ej() {
    while true; do
        local disk="$(ls /Volumes | grep LaCie | head -1)"
        [[ -z "$disk" ]] && break
        diskutil eject "$disk"
    done
}

function mue() {
    which deactivate &>/dev/null && deactivate
    source $HOME/.lib/markup-export/.pyv/bin/activate
    $HOME/.lib/markup-export/main $@
    _pyv_cd
}

# options
setopt no_beep
## history
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size
                                  # exceeds HISTSIZE.
setopt hist_ignore_dups       # ignore duplicated commands history list.
setopt hist_ignore_space      # ignore commands that start with space.
setopt hist_verify            # show command with history expansion to user
                                  # before running it.
setopt share_history          # live-append to history file, share items
                                  # between sessions
