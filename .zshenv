# omz
export ZSH="${HOME}/.oh-my-zsh"
export ZDOTDIR=~/.zsh
export PATH="${PATH}:${HOME}/_bin:${HOME}/.flutter/bin:/Applications/Postgres.app/Contents/Versions/latest/bin/"

export EDITOR=vim
export TREE_COLORS="di=1;36:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43"

# fd
export FD_OPTIONS=("--hidden" "--follow" "--ignore-file" "~/.ignore")
# fzf
export FZF_DEFAULT_OPTS="--height 60% --reverse --no-info --cycle --bind 'tab:down' --prompt='» ' --pointer='→' --color 'fg+:255:underline,hl:189,hl+:183,bg+:-1,marker:183,pointer:183,spinner:183,prompt:189:regular,query:189:regular:italic'"
export FZF_DEFAULT_COMMAND="git ls-files --cached --others --exclude-standard 2>/dev/null || fd --type f --type l $FD_OPTIONS"
# rg
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"

