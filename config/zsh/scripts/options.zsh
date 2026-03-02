setopt no_beep

# history
# increase number of history elements
HISTSIZE=1000000
SAVEHIST=$HISTSIZE
# delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_expire_dups_first
# ignore duplicated commands history list
setopt hist_ignore_dups
setopt hist_ignore_all_dups
setopt hist_save_no_dups
# remove superfluous blanks
setopt hist_reduce_blanks
# show command with history expansion to user before running it
setopt hist_verify
# live-append to history file, share items between sessions
setopt share_history
