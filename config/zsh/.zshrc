# completion
autoload -U compinit; compinit
# vi keybindings
bindkey -v

for d in $ZDOTDIR/scripts $ZDOTDIR/plugins $HOME/.config/zv; do
    if $(test -d $d); then
        for script in $(find $d -name '*.zsh'); do
            source $script
        done
    fi
done

source $ZDOTDIR/plugins-other/plugins.zsh

# pick directory if shell is start in in home dir
[[ "$(pwd)" == "$HOME" ]] && df
