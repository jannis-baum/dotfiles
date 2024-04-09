function pyv() {
    local pyv_path="$HOME/.pyv"
    mkdir -p $pyv_path

    local arg_help arg_list arg_new
    case "$1" in
        "-h" | "--help") arg_help=1;;
        "-l" | "--list") arg_list=1;;
        "-n" | "--new") arg_new=1;;
        "-"*)
            echo "Illegal option: $1" >&2
            arg_help=1;;
    esac

    if [[ -n "$arg_help" ]]; then
        cat <<EOF
usage: pyv [-h] [-l] [-n "new_env"] ["activate_env"]

options:
  -h, --help            show this help message and exit
  -l, --list            list environments
  -n, --new "new_env"   create a new environment named "new_env"
  "activate_env"        activate given environment
EOF
        return
    fi

    if [[ -n "$arg_new" ]]; then
        local new_env="$2"
        if [[ -z "$new_env" ]]; then
            echo "Please provide a name for the new environment to create." >&2
            return
        fi
        local new_path="$pyv_path/$new_env"
        if test -e "$new_path"; then
            echo "Environment \"$new_env\" already exists, exiting." >&2
            return
        fi
        /usr/bin/env python3 -m venv "$new_path"
        return
    fi

    if [[ -n "$arg_list" ]]; then
        ls "$pyv_path"
        return
    fi

    if [[ -n "$1" ]]; then
        local act_path="$pyv_path/$1/bin/activate"
        if ! test -f "$act_path"; then
            echo "Environment \"$1\" does not exist or is broken." >&2
            return
        fi
        source "$act_path"
    fi
}
