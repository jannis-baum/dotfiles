# recent commands matching prefix
# up
autoload -U up-line-or-beginning-search
zle -N up-line-or-beginning-search
bindkey -M vicmd k up-line-or-beginning-search
# down
autoload -U down-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey -M vicmd j down-line-or-beginning-search

# shift+tab to go back in completion
bindkey -M viins "${terminfo[kcbt]}" reverse-menu-complete
bindkey -M vicmd "${terminfo[kcbt]}" reverse-menu-complete

# si-vim
bindkey ^u _si_vim_widget

# fzf-dotfiles
FZFDF_ACT_RELOAD=left

# git.zsh-dotfiles
GDF_GSI_STAGE=left
