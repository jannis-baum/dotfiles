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
  new        create a new project/environment, see \`uvz new --help\`
  location   show path of uvz for current directory if one exists
EOF
            ;;
    esac
}

function _uvz_new() {
    # MARK: ARUGMENT PARSING ---------------------------------------------------
    # from https://gist.github.com/jannis-baum/d3e5744466057f4e61614744a2397fdd
    local arg_help="" positional=() set_uv_args uv_args=()

    while (( $# )); do
        _echo_error() {
            echo "$1" >&2
            arg_help=1; break
        }
        local arg="$1"; shift

        if [[ -n "$set_uv_args" ]]; then
            uv_args+=("$arg")
            continue
        fi

        case "$arg" in
            "-h" | "--help") arg_help=1; continue;;
            "-") set_uv_args=1; continue;;
        esac

        [[ "$arg" == "-"* ]] && _echo_error "Unknown option: $arg"
        positional+=("$arg")
    done
    which _echo_error >/dev/null && unfunction _echo_error

    if [[ -n "$arg_help" ]]; then
        cat <<EOF
usage: uvz new [-h] [- [uv init args ...]]

Create a new project and environment and activate it, or create only the
environment if there is already a project.

positional arugments:
  name                   Name for the new environment (defaults to basename of
                         current directory).

options:
  -h, --help             Show this help message and exit.
  -                      Use all additional arguments for \`uv init\`.
EOF
        return
    fi
    # MARK: ARUGMENT PARSING done ----------------------------------------------

    local new_path=".venv"
    if test -d "$new_path"; then
        echo "uvz environment already exists here, exiting." >&2
        return
    fi

    if ! test -f "pyproject.toml"; then
        uv init "${uv_args[@]}" || return
    fi
    uv venv

    source "$new_path/bin/activate"
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
