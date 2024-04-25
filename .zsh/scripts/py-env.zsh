function pyv() {
    local pyv_path="$HOME/.pyv"
    mkdir -p $pyv_path

    # MARK: ARUGMENT PARSING ---------------------------------------------------
    # from https://gist.github.com/jannis-baum/d3e5744466057f4e61614744a2397fdd
    local arg_help="" positional=() arg_list arg_new arg_noipython

    while (( $# )); do
        _echo_error() {
            echo "$1" >&2
            arg_help=1; break
        }
        local arg="$1"; shift

        case "$arg" in
            "-h" | "--help") arg_help=1; continue;;
            "-l" | "--list") arg_list=1; continue;;
            "-p" | "--no-ipython") arg_noipython=1; continue;;
            "-n" | "--new")
                [[ -z "$1" ]] && _echo_error "Missing argument for --new"
                arg_new="$1"; shift;
                continue;;
        esac

        [[ "$arg" == "-"* ]] && _echo_error "Illegal option: $arg"
        positional+=("$arg")
    done
    unfunction _echo_error

    if [[ -n "$arg_help" ]]; then
        cat <<EOF
usage: pyv [-h] [-l] [-n "new_env"] ["activate_env"]

options:
  -h, --help            show this help message and exit
  -l, --list            list environments
  -n, --new "new_env"   create a new environment named "new_env" and activate it
  -p, --no-ipython      don't install ipykernel for a new environment
  "activate_env"        activate given environment
EOF
        return
    fi
    # MARK: ARUGMENT PARSING done ----------------------------------------------

    if [[ -n "$arg_new" ]]; then
        local new_path="$pyv_path/$arg_new"
        if test -e "$new_path"; then
            echo "Environment \"$arg_new\" already exists, exiting." >&2
            return
        fi

        /usr/bin/env python3 -m venv "$new_path"
        pyv "$arg_new"

        if [[ -z "$arg_noipython" ]]; then
            pip install ipykernel
            ipython kernel install --user --name="$arg_new"
            # iphython kernel install fucks up the environment so we have to
            # reactivate it
            deactivate
            pyv "$arg_new"
            pip install jupyterlab
        fi
        return
    fi

    if [[ -n "$arg_list" ]]; then
        ls "$pyv_path"
        return
    fi

    local activate_env="$positional[1]"
    if [[ -n "$activate_env" ]]; then
        local act_path="$pyv_path/$activate_env/bin/activate"
        if ! test -f "$act_path"; then
            echo "Environment \"$activate_env\" does not exist or is broken." >&2
            return
        fi
        source "$act_path"
    fi
}

function _pyv() {
    compadd "${(@)${(f)$(pyv -l)}}"
}
compdef _pyv pyv
