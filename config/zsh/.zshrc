# completion
autoload -U compinit; compinit
# vi keybindings
bindkey -v

# PATH
export PATH=$(tr -d ' ' <<<"\
    :/Library/TeX/texbin/\
    :/Applications/Postgres.app/Contents/Versions/latest/bin/\
    :$HOME/.flutter/bin/\
    :$HOME/.pub-cache/bin/\
    :$PATH
")

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

source $ZDOTDIR/plugins-other/plugins.zsh

for d in $ZDOTDIR/plugins $HOME/.config/zv $ZDOTDIR/scripts; do
    if $(test -d $d); then
        for script in $(find $d -name '*.zsh'); do
            source $script
        done
    fi
done
