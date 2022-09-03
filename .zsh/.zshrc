export PS1="%F{189}✻%f %2~ » "

# vi keybindings
bindkey -v

for script in $(find $ZDOTDIR/scripts -name '*.zsh'); do
    source $script
done
