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

    local out=$((
        local prefix="."
        while [[ "$(pwd)" != "/" ]]; do
            local dir="$(realpath .)"
            local path_comp="$_fbm_path_color$prefix/$(basename "$dir")/\\x1b[0m"
            test -f '.fbms' && cat .fbms | sed -e "s|^|$dir\t$path_comp|"
            cd ..
            prefix="$prefix."
        done
    ) | fzf --delimiter="\t" --ansi \
        --with-nth=2 --nth=2 \
        --expect=ctrl-o \
    )

    local key=$(head -1 <<< $out)
    local pick=$(tail -n +2 <<< $out)

    [[ -z "$pick" ]] && return

    if [[ "$key" == "ctrl-o" ]]; then
        $EDITOR "$(cut -f1 <<< "$pick")/.fbms"
    else
        open "$(cut -f3 <<< "$pick")"
    fi
}
