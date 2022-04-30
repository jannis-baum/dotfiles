# hidden files & dirs
setopt globdots
# typos
setopt correct_all

autoload -U compinit; compinit

# menu takes up less space
setopt list_packed
# show selection
zstyle ':completion:*' menu select

# case & hyphen insensitive, substrings
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# cache
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$HOME/.zsh/.zcompcache"
