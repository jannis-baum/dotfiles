export ZDOTDIR=~/.zsh
export PATH="$PATH:$HOME/.bin:$HOME/.flutter/bin:/Applications/Postgres.app/Contents/Versions/latest/bin/"

export EDITOR=vim
export MANPAGER="col -b | vim -c 'set ft=man nomod nolist ignorecase' --not-a-term -"
export TREE_COLORS="di=1;36:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43"

# fd
export FD_OPTIONS=("--hidden" "--follow" "--strip-cwd-prefix")
# fzf
export FZF_DEFAULT_OPTS="--height 60% --reverse --no-info --cycle --bind 'tab:down' --bind 'ctrl-f:reload($FZF_ALL_COMMAND)' --prompt='» ' --pointer='→' --color 'fg+:255:underline,hl:189,hl+:183,bg+:-1,marker:183,pointer:183,spinner:183,prompt:189:regular,query:189:regular:italic'"
export FZF_ALL_COMMAND="fd --type f --type l --no-ignore $FD_OPTIONS"
export FZF_DEFAULT_COMMAND="fd --type f --type l $FD_OPTIONS"
# rg
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"
