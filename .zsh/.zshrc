export PS1=$'%F{183}%f%K{183}%F{235}✻%f%k%F{183}%f %F{248}%{\x1b[3m%}%2~%{\x1b[0m%}%f %B»%b '

# vi keybindings
bindkey -v

if $(test -d $ZDOTDIR/scripts); then
    for script in $(find $ZDOTDIR/scripts -name '*.zsh'); do
        source $script
    done
fi
