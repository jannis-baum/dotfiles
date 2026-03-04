# pick from command history
function history-wrapper() {
        # re-read history file to get shared commands from other sessions
        [[ -z $BUFFER ]] && fc -R $HISTFILE
        zle _fzf_history
        # go to insert
        zle vi-insert
}
zle -N history-wrapper
bindkey  "^[[A" history-wrapper
bindkey  "^[[B" history-wrapper
bindkey  -M vicmd k history-wrapper
bindkey  -M vicmd j history-wrapper

# shift+tab to go back in completion
bindkey -M viins "${terminfo[kcbt]}" reverse-menu-complete
bindkey -M vicmd "${terminfo[kcbt]}" reverse-menu-complete

# si-vim
bindkey ^u _si_vim_widget

# fzf-dotfiles
FZFDF_ACT_RELOAD=left

# git.zsh-dotfiles
GDF_GSI_STAGE=left
