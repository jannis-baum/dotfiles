export PS1=$'%F{183}%f%K{183}%F{235}✻%f%k%F{183}%f %F{248}%{\x1b[3m%}%2~%{\x1b[0m%}%f %B»%b '

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

for d in scripts plugins; do
    if $(test -d $ZDOTDIR/$d); then
        for script in $(find $ZDOTDIR/$d -name '*.zsh'); do
            source $script
        done
    fi
done
