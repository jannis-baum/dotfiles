sdf() {
    # load config, go to dotfiles_dir and setup ignore
    typeset -A dotfiles_actions
    [[ -n "$SDFRC_PATH" ]] && source "$SDFRC_PATH" || source ~/.sdfrc
    dotfiles_dir=$(realpath $dotfiles_dir)
    cd $dotfiles_dir
    ignore_patterns+=('.git/*' '.gitignore' '.gitmodules')

    # prompt to install of $1 to $2
    install_dotfile() {
        read -q "answer?install $1? (y/*) "
        if [[ $answer = 'y' ]]; then
            mkdir -p "$(dirname $2)"
            cp -r "$1" "$2"
            printf '\n'
            for rgx cmd in ${(kv)dotfiles_actions}; do
                [[ "$1" =~ "$rgx" ]] && echo "  -> $cmd" && ${(z)cmd}
            done
        else printf '\n'
        fi
    }

    # find submodules
    if [[ -f '.gitmodules' ]]; then
        submodules=("${(f)$(rg --no-line-number --replace '' '^\s*path ?= ?' '.gitmodules')}")
        ignore_patterns+=("${(@)submodules}")
    fi

    # install submodules if newer than submodule in $HOME
    for sm in $submodules; do
        if [[ "$sm" -nt "$HOME/$sm"  || ! -d "$HOME/$sm" ]]; then
            install_dotfile "$sm" "$HOME/$sm"
        fi
    done

    # find dotfiles
    fd_opts=('--strip-cwd-prefix' '--type' 'f' '--type' 'l' '--hidden' '--no-ignore')
    fd_opts+=("${(z)$(printf '%s\n' ${ignore_patterns} | sed 's/^/--exclude /' | tr '\n' ' ')}")
    dotfiles=("${(f)$(fd $fd_opts)}")

    # install files if different from file in $HOME
    for df in $dotfiles; do
        if ! cmp "$df" "$HOME/$df" &> /dev/null; then
            install_dotfile "$df" "$HOME/$df"
        fi
    done
}
