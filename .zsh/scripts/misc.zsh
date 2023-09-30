# aliases
alias c="printf '\n%.0s' {2..$LINES} && clear"
alias ej="diskutil eject /Volumes/LaCie*"
alias w='printf "%s" "$(VISUAL=vim vipe)" | pbcopy'
alias ssh='kitty +kitten ssh'
alias trm='trash -F'
alias g='gsi'
alias mue="~/.lib/markup-export/main"

# options
setopt no_beep
## history
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
