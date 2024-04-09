# completion
autoload -U compinit; compinit
# vi keybindings
bindkey -v

# PATH
export PATH=$(tr -d ' ' <<<"\
     /opt/homebrew/bin\
    :$HOME/.bin/\
    :/Library/TeX/texbin/\
    :/Applications/Postgres.app/Contents/Versions/latest/bin/\
    :$HOME/.flutter/bin/\
    :$HOME/.pub-cache/bin/\
    :$PATH
")

for d in $ZDOTDIR/scripts $ZDOTDIR/plugins $HOME/.zv; do
    if $(test -d $d); then
        for script in $(find $d -name '*.zsh'); do
            source $script
        done
    fi
done

source $ZDOTDIR/plugins-other/plugins.zsh
