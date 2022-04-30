export PS1="%F{189}✻%f %2~ » "

# vi keybindings
bindkey -v

for script in $ZDOTDIR/scripts/*; do
    source $script
done

