export PS1="%F{189}✻%f %2~ » "

# vi keybindings
bindkey -v

if $(test -d $ZDOTDIR/scripts); then
    for script in $(find $ZDOTDIR/scripts -name '*.zsh'); do
        source $script
    done
fi
