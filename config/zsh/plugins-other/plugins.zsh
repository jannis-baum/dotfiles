# fzf
source "$ZDOTDIR/plugins-other/fzf-tab-completion/zsh/fzf-zsh-completion.sh"
bindkey '^I' fzf_completion
zstyle ':completion:*' fzf-search-display true

# lazy-load nvm because loading it is super slow
function _lazy_load_nvm {
    # remove lazy-loading functions
    unfunction nvm node _lazy_load_nvm

    export NVM_DIR="$HOME/.nvm"
    # load nvm
    [[ -s "/opt/homebrew/opt/nvm/nvm.sh" ]] && source "/opt/homebrew/opt/nvm/nvm.sh"
    # nvm completion
    [[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ]] && source "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"
}

function nvm() {
    _lazy_load_nvm
    nvm $@
}

function node() {
    _lazy_load_nvm
    node $@
}
