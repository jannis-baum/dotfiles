export ZDOTDIR=~/.zsh

export EDITOR=vim
export MANPAGER="col -b | vim -c 'set ft=man nomod nolist ignorecase' --not-a-term -"

# fd
export FD_OPTIONS=("--hidden" "--follow" "--strip-cwd-prefix")
# fzf
export FZF_DEFAULT_COMMAND="fd --type f --type l $FD_OPTIONS"
export FZF_DEFAULT_OPTS="
    --height 60% --reverse --no-info --cycle
    --preview-window='right,60%,wrap,hidden'
    --preview 'bat --style=numbers --color=always {}'
    --prompt='» ' --pointer='→'
    --color 'fg+:255:underline,hl:189,hl+:183,bg+:-1,marker:183,pointer:183,spinner:183,prompt:189:regular,query:189:regular:italic'
    --bind 'tab:down'
    --bind \"left:reload(fd --type f --type l --no-ignore $FD_OPTIONS)\"
    --bind 'right:toggle-preview'"
# rg
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"
# colors
export LS_COLORS="fi=1;38;5;252:di=3;38;5;248:ex=4;38;5;175"
export EXA_COLORS="sn=38;5;183:sb=1;38;5;183:da=38;5;153"

# PATH
export PATH="$PATH\
    :$HOME/.bin/\
    :/Library/TeX/texbin/\
    :/Applications/Postgres.app/Contents/Versions/latest/bin/\
    :$HOME/.flutter/bin/"
