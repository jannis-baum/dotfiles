function uvz() {
    case "$1" in
        "new")
            shift
            _uvz_new $@
            ;;
        "location")
            local uvz_dir=$(_uvz_find)
            [[ -n "$uvz_dir" ]] && echo "$uvz_dir"
            ;;
        *) cat <<EOF
usage: uvz [new | location | help]

Minimal zsh-centered Python virtual env management using uv

positional aguments
  help       show this help message and exit
  new        create a new environment, see \`uvz new --help\`
  location   show path of uvz for current directory if one exists
EOF
            ;;
    esac
}

function _uvz_new() {
    # MARK: ARUGMENT PARSING ---------------------------------------------------
    # from https://gist.github.com/jannis-baum/d3e5744466057f4e61614744a2397fdd
    local arg_help="" positional=() arg_version arg_jupyter arg_noreqs

    while (( $# )); do
        _echo_error() {
            echo "$1" >&2
            arg_help=1; break
        }
        local arg="$1"; shift

        case "$arg" in
            "-h" | "--help") arg_help=1; continue;;
            "-j" | "--jupyter") arg_jupyter=1; continue;;
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
usage: uvz new [-h] [-np] [-nr] [-v] [name]

Create a new environment and activate it

positional arugments:
  name                          name for the new environment (defaults to
                                basename of current directory)

options:
  -h, --help                    show this help message and exit
  -v, --version                 the python version to use, defaults to locally
                                set pyenv version if exists
  -j, --jupyter                 install Jupyter Lab for the new environment
  -nr, --no-requirements        don't install existing requirements.txt
EOF
        return
    fi
    # MARK: ARUGMENT PARSING done ----------------------------------------------

    local arg_name="$positional[1]"
    [[ -z "$arg_name" ]] \
        && arg_name="$(basename "$(realpath .)")"

    local new_path=".venv"
    if test -d "$new_path"; then
        echo "uvz already exists here, exiting." >&2
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

    if ! pyenv exec python -m venv "$new_path" --prompt "uvz:$arg_name" 2>/dev/null; then
        echo 'Please specify a version with `-v` or set it locally with `pyenv local "version"`.' >&2
        _error_version
        return 1
    fi
    unfunction _error_version
    source "$new_path/bin/activate"

    if [[ -n "$arg_jupyter" ]]; then
        pip install jupyterlab
    fi

    if [[ -z "$arg_noreqs" ]] && test -f requirements.txt; then
        pip install -r requirements.txt
    fi
}

function _uvz_find() {
    [[ "$(pwd)" != $HOME* ]] && return
    while [[ "$(pwd)" != "$HOME" ]]; do
        if test -d .venv; then
            echo "$(pwd)/.venv"
            break
        fi
        # -q omits chpwd hooks
        cd -q ..
    done
}

function _uvz_cd() {
    # deactivate if we can
    which deactivate >/dev/null && deactivate

    local uvz_dir=$(_uvz_find)
    # if there is no (valid) uvz_dir return
    {[[ -z "$uvz_dir" ]] || ! test -f "$uvz_dir/bin/activate"} && return
    # else we can activate
    source "$uvz_dir/bin/activate"
}
autoload -U add-zsh-hook
add-zsh-hook chpwd _uvz_cd

# for initial uvz
# CAUTION! this needs to happen after `pyenv init -`
_uvz_cd
