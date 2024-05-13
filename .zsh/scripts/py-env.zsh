function pyv() {
    case "$1" in
        "new")
            shift
            _pyv_new $@
            ;;
        "location")
            local pyv_dir=$(_pyv_find)
            [[ -n "$pyv_dir" ]] && echo "$pyv_dir"
            ;;
        *) cat <<EOF
usage: pyv [new | location | help]

Minimal zsh-centered Python virtual env management using pyenv, venv & pip

positional aguments
  help       show this help message and exit
  new        create a new environment, see \`pyv new --help\`
  location   show path of pyv for current directory if one exists
EOF
            ;;
    esac
}

function _pyv_new() {
    # MARK: ARUGMENT PARSING ---------------------------------------------------
    # from https://gist.github.com/jannis-baum/d3e5744466057f4e61614744a2397fdd
    local arg_help="" positional=() arg_version arg_noipython arg_noreqs

    while (( $# )); do
        _echo_error() {
            echo "$1" >&2
            arg_help=1; break
        }
        local arg="$1"; shift

        case "$arg" in
            "-h" | "--help") arg_help=1; continue;;
            "-np" | "--no-ipython") arg_noipython=1; continue;;
            "-nr" | "--no-requirements") arg_noreqs=1; continue;;
            "-v" | "--version")
                [[ -z "$1" || "$1" == -* ]] && _echo_error "Version not specified"
                arg_version="$1"; shift;
                continue;;
        esac

        [[ "$arg" == "-"* ]] && _echo_error "Unknown option: $arg"
        positional+=("$arg")
    done
    which _echo_error >/dev/null && unfunction _echo_error

    if [[ -n "$arg_help" ]]; then
        cat <<EOF
usage: pyv new [-h] [-np] [-nr] [-v] [name]

Create a new environment and activate it

positional arugments:
  name                          name for the new environment (defaults to
                                basename of current directory)

options:
  -h, --help                    show this help message and exit
  -v, --version                 the python version to use, defaults to locally
                                set pyenv version if exists
  -np, --no-ipython             don't install ipykernel for the new environment
  -nr, --no-requirements        don't install existing requirements.txt
EOF
        return
    fi
    # MARK: ARUGMENT PARSING done ----------------------------------------------

    local arg_name="$positional[1]"
    [[ -z "$arg_name" ]] \
        && arg_name="$(basename "$(realpath .)")"

    local new_path=".pyv"
    if test -d "$new_path"; then
        echo "pyv already exists here, exiting." >&2
        return
    fi

    _error_version() {
        echo "Available versions are:"
        pyenv versions | grep -v "system"
    }

    if [[ -n "$arg_version" ]]; then
        if ! pyenv local "$arg_version" 2>/dev/null; then
            echo "Version $arg_version is not available."
            _error_version
            return 1
        fi
    fi

    if ! pyenv exec python -m venv "$new_path" --prompt "pyv:$arg_name" 2>/dev/null; then
        echo 'Please specify a version with `-v` or set it locally with `pyenv local "version"`.' >&2
        _error_version
        return 1
    fi
    unfunction _error_version
    source "$new_path/bin/activate"

    if [[ -z "$arg_noipython" ]]; then
        pip install jupyterlab
    fi

    if [[ -z "$arg_noreqs" ]] && test -f requirements.txt; then
        pip install -r requirements.txt
    fi
}

function _pyv_find() {
    [[ "$(pwd)" != $HOME* ]] && return
    while [[ "$(pwd)" != "$HOME" ]]; do
        if test -d .pyv; then
            echo "$(pwd)/.pyv"
            break
        fi
        # -q omits chpwd hooks
        cd -q ..
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
# CAUTION! this needs to happen after `pyenv init -`
_pyv_cd
