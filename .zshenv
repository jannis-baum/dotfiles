export ZDOTDIR=~/.zsh

export EDITOR=vim
export MANPAGER="col -b | vim -c 'set ft=man nomod nolist ignorecase' --not-a-term -"

export PATH="$PATH:$HOME/.bin/"
# fd
export FD_OPTIONS=("--hidden" "--follow" "--strip-cwd-prefix")
# fzf
export FZF_DEFAULT_COMMAND="fd --type f --type l $FD_OPTIONS"
export FZF_DEFAULT_OPTS="
    --height 60% --reverse --no-info --cycle
    --preview-window='right,70%,wrap,hidden'
    --preview 'bat --style=numbers --color=always {}'
    --prompt='» ' --pointer='→'
    --color 'fg+:255:underline,hl:189,hl+:183,bg+:-1,marker:183,pointer:183,spinner:183,prompt:189:regular,query:189:regular:italic'
    --bind 'tab:down'
    --bind \"left:reload(fd --type f --type l --no-ignore $FD_OPTIONS)\"
    --bind 'right:toggle-preview'"
# rg
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"

# flutter
export PATH="$PATH:$HOME/.flutter/bin/"

# postgres
export PATH="$PATH:/Applications/Postgres.app/Contents/Versions/latest/bin/"
