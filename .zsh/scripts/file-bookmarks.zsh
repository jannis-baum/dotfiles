_fb_path_color=$(sed -r 's/^.*di=([^:]+):.*$/\1/' <<< $LS_COLORS)
[[ -n "$_fb_path_color" ]] && _fb_path_color="\\x1b[${_fb_path_color}m"

function fb() {
    if [[ "$1" == "-n" || "$1" == "--new" ]]; then
        if [[ "$#" != "3" ]]; then
            echo "usage: fb [-n | --new] name uri"
            return 1
        fi
        echo "$2\t$3" >> .fbs
        return
    fi

    # cd -q omits chpwd hooks
    local out=$((
        local prefix="."
        while [[ "$(pwd)" != "/" ]]; do
            local dir="$(realpath .)"
            local path_comp="$_fb_path_color$prefix/$(basename "$dir")/\\x1b[0m"
            test -f '.fbs' && cat .fbs | sed -e "s|^|$dir\t$path_comp|"
            cd -q ..
            prefix="$prefix."
        done
    ) | fzf --delimiter="\t" --ansi \
        --with-nth=2 \
        --expect=ctrl-o \
    )

    local key=$(head -1 <<< $out)
    local pick=$(tail -n +2 <<< $out)

    [[ -z "$pick" ]] && return

    if [[ "$key" == "ctrl-o" ]]; then
        $EDITOR "$(cut -f1 <<< "$pick")/.fbs"
    else
        open "$(cut -f3 <<< "$pick")"
    fi
}
