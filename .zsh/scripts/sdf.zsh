sdf() {
    # load config, go to dotfiles_dir and setup ignore
    typeset -A dotfiles_actions
    [[ -n "$SDFRC_PATH" ]] && source "$SDFRC_PATH" || source ~/.sdfrc
    dotfiles_dir=$(realpath $dotfiles_dir)

    if [[ "$1" == '-u' || "$1" == '--upgrade' ]]; then
        echo "\e[1mupgrading repo\e[0m"
        git -C $dotfiles_dir pull
        echo "\e[1mupgrading submodules\e[0m"
        git -C $dotfiles_dir submodule foreach git pull
        return
    fi

    prev_dir=$(pwd)
    cd $dotfiles_dir
    ignore_patterns+=('.git/*' '.gitignore' '.gitmodules')

    # make it possible for read to get answer from stdin (e.g. `yes`)
    [[ -t 0 ]] && readq_flags=('-q') || readq_flags=('-q' '-u' '0' '-E')

    # prompt to install of $1 to $2, i.a. run custom command
    install_dotfile() {
        printf "install $1? (y/*) "
        if read $readq_flags; then
            [[ -d $2 ]] && rm -rf $2 # directories aren't overwritten -> delete first
            mkdir -p "$(dirname $2)"
            cp -r "$1" "$2"
            printf '\n'
            for rgx cmd in ${(kv)dotfiles_actions}; do
                [[ "$1" =~ "$rgx" ]] && echo "  \e[2m\e[3m-> $cmd\e[0m" && ${(z)cmd}
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

    cd $prev_dir
}
