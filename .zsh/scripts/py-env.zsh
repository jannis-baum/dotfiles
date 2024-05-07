function pyv() {
    # MARK: ARUGMENT PARSING ---------------------------------------------------
    # from https://gist.github.com/jannis-baum/d3e5744466057f4e61614744a2397fdd
    local arg_help="" positional=() arg_location arg_new arg_noipython arg_noreqs

    while (( $# )); do
        _echo_error() {
            echo "$1" >&2
            arg_help=1; break
        }
        local arg="$1"; shift

        case "$arg" in
            "-h" | "--help") arg_help=1; continue;;
            "-l" | "--location") arg_location=1; continue;;
            "-np" | "--no-ipython") arg_noipython=1; continue;;
            "-nr" | "--no-requirements") arg_noreqs=1; continue;;
            "-n" | "--new")
                if [[ -z "$1" || "$1" == -* ]]; then
                    arg_new="$(basename "$(realpath .)")"
                else
                    arg_new="$1"; shift;
                fi
                continue;;
        esac

        [[ "$arg" == "-"* ]] && _echo_error "Unknown option: $arg"
        positional+=("$arg")
    done
    unfunction _echo_error

    if [[ -n "$arg_help" ]]; then
        cat <<EOF
usage: pyv [-h] [-l] [-n ["new_env"]]

options:
  -h, --help               show this help message and exit
  -l, --location           show path of pyv for current directory if exists
  -n, --new ["new_env"]    - create a new environment named "new_env" (default
                             name of current directory)
                           - activate it
                           - install requirements.txt if exist
                           - install ipython kernel unless -p is specified
  -np, --no-ipython        don't install ipykernel for a new environment
  -nr, --no-requirements   don't install requirements.txt
EOF
        return
    fi
    # MARK: ARUGMENT PARSING done ----------------------------------------------

    if [[ -n "$arg_new" ]]; then
        local new_path=".pyv"
        if test -d "$new_path"; then
            echo "pyv already exists here, exiting." >&2
            return
        fi

        /usr/bin/env python3 -m venv "$new_path" --prompt "pyv:$arg_new"
        source "$new_path/bin/activate"

        if [[ -z "$arg_noipython" ]]; then
            pip install ipykernel
            ipython kernel install --user --name="$arg_new"
            # iphython kernel install fucks up the environment so we have to
            # reactivate it
            deactivate
            source "$new_path/bin/activate"
            pip install jupyterlab
        fi

        if [[ -z "$arg_noreqs" ]] && test -f requirements.txt; then
            pip install -r requirements.txt
        fi

        return
    fi

    if [[ -n "$arg_location" ]]; then
        local pyv_dir=$(_pyv_find)
        [[ -n "$pyv_dir" ]] && echo "$pyv_dir"
        return
    fi
}

function _pyv_find() {
    while [[ "$(pwd)" != "$HOME" ]]; do
        if test -d .pyv; then
            echo "$(pwd)/.pyv"
            break
        fi
        cd ..
    done
}

function _pyv_cd() {
    # deactivate if we can
    which deactivate >/dev/null && deactivate

    local pyv_dir=$(_pyv_find)
    # if there is no (valid) pyv_dir return
    {[[ -z "$pyv_dir" ]] || ! test -f "$pyv_dir/bin/activate"} && return
    # else we can activate
    source "$pyv_dir/bin/activate"
}
autoload -U add-zsh-hook
add-zsh-hook chpwd _pyv_cd
# for initial pyv
_pyv_cd
