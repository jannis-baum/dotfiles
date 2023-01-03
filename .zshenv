export ZDOTDIR=~/.zsh

export EDITOR=vim
export MANPAGER="col -b | vim -c 'set ft=man nomod nolist ignorecase' --not-a-term -"

# fzf
export FZF_DEFAULT_OPTS="
    --height 60% --reverse --no-info --cycle
    --preview-window='right,60%,wrap,hidden,border-sharp'
    --preview 'bat --style=numbers --color=always {}'
    --prompt=' ╰➤ ' --pointer='→'
    --color 'fg+:255:underline,bg+:-1'
    --color 'hl:189,hl+:183'
    --color 'prompt:183:bold,query:regular:italic'
    --color 'marker:183,pointer:183,spinner:183,info:189'
    --bind 'tab:down'
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
