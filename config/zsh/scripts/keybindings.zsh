# recent commands matching prefix
# up
autoload -U up-line-or-history
# helper to re-read history file to get shared commands from other sessions
up-line-or-history-reread() {
        [[ -z $BUFFER ]] && fc -R $HISTFILE
        zle up-line-or-history
}
zle -N up-line-or-history-reread
bindkey  -M vicmd k up-line-or-history-reread
# down
autoload -U down-line-or-history
down-line-or-history-reread() {
        [[ -z $BUFFER ]] && fc -R $HISTFILE
        zle down-line-or-history
}
zle -N down-line-or-history-reread
bindkey  -M vicmd j down-line-or-history-reread

# shift+tab to go back in completion
bindkey -M viins "${terminfo[kcbt]}" reverse-menu-complete
bindkey -M vicmd "${terminfo[kcbt]}" reverse-menu-complete

# si-vim
bindkey ^u _si_vim_widget

# fzf-dotfiles
FZFDF_ACT_RELOAD=left

# git.zsh-dotfiles
GDF_GSI_STAGE=left
