setopt no_beep

# history
# delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_expire_dups_first
# ignore duplicated commands history list
setopt hist_ignore_dups
# ignore commands that start with space
setopt hist_ignore_space
# show command with history expansion to user before running it
setopt hist_verify
# live-append to history file, share items between sessions
setopt share_history
