export XDG_CONFIG_HOME=$HOME/.config
export ZDOTDIR=$XDG_CONFIG_HOME/zsh

export EDITOR=siv
export MANPAGER="col -b | nvim -c 'set ft=man nomod nolist ignorecase' -"

# fzf
export FZF_DEFAULT_OPTS="
    --height 60% --reverse --no-info --cycle
    --preview-window='right,60%,wrap,hidden,border-sharp'
    --prompt=' ╰➤ '
    --pointer='→'
    --bind 'tab:down'
    --bind 'right:toggle-preview'"
# rg
export RIPGREP_CONFIG_PATH="$HOME/.config/rg/ripgreprc"

export CHROME_EXECUTABLE=/Applications/Chromium.app/Contents/MacOS/Chromium

export TITR_DATA_DIR="$HOME/Library/Mobile Documents/com~apple~CloudDocs/titr-data"
