_fbm_path_color=$(sed -r 's/^.*di=([^:]+):.*$/\1/' <<< $LS_COLORS)
[[ -n "$_fbm_path_color" ]] && _fbm_path_color="\\x1b[${_fbm_path_color}m"

function fbm() {
    if [[ "$1" == "-n" || "$1" == "--new" ]]; then
        if [[ "$#" != "3" ]]; then
            echo "usage: fbm [-n | --new] name uri"
            return 1
        fi
        echo "$2\t$3" >> .fbms
        return
    fi

    local target=$((
        local prefix="."
        while [[ "$(pwd)" != "/" ]]; do
            local path_comp="$_fbm_path_color$prefix/$(basename "$(realpath .)")/\\x1b[0m"
            test -f '.fbms' && cat .fbms | sed -e "s|^|$path_comp|"
            cd ..
            prefix="$prefix."
        done
    ) | fzf --delimiter="\t" --with-nth=1 --ansi)

    [[ -z "$target" ]] && return
    open "$(cut -f2 <<< "$target")"
}
