_rem_remote="hpc"
_rem_mnt_path="$HOME/_/hpi/hpc"

# MARK: main function ----------------------------------------------------------

function rem() {
    # arugment parsing from
    # https://gist.github.com/jannis-baum/d3e5744466057f4e61614744a2397fdd
    local arg_help arg_status arg_unmount arg_mount arg_cd positional=()

    while (( $# )); do
        _echo_error() {
            echo "$1" >&2
            arg_help=1; break
        }
        local arg="$1"; shift

        case "$arg" in
            -[^-]*)
                for opt in ${(s::)arg[2,-1]}; do
                    case "$opt" in
                        "h") arg_help=1;;
                        "u") arg_unmount=1;;
                        "m") arg_mount=1;;
                        "d") arg_cd=1;;
                        "s") arg_status=1;;
                        *) _echo_error "Unknown option: -$opt";;
                    esac
                done
                continue;;
            "--help") arg_help=1; continue;;
            "--unmount") arg_unmount=1; continue;;
            "--mount") arg_mount=1; continue;;
            "--cd") arg_cd=1; continue;;
            "--status") arg_status=1; continue;;
            "--"*) _echo_error "Unknown option: $arg";;
        esac

        positional+=("$arg")
    done
    which _echo_error >/dev/null && unfunction _echo_error

    if [[ -n "$arg_help" ]]; then
        cat <<EOF
usage: rem [command [args]]

SSHFS-focussed remote workflow, acts like \`ssh $_rem_remote\`

options ():
  -h, --help         print this message and exit
  -u, --unmount      unmount remote home
  -m, --mount        mount remote home
  -d, --cd           change to mount directory
  -s, --status       get mount information

short options can be combined, e.g. \`-mds\`, and will be executed in the order
above. execution stops if one option returns non-zero
EOF
        return
    fi

    [[ -n "$arg_unmount" ]] && {_rem_unmount || return 1}
    [[ -n "$arg_mount" ]] &&  {_rem_mount || return 1}
    [[ -n "$arg_cd" ]] && {_rem_cd || return 1}
    [[ -n "$positional" ]] && {_rem_ssh $positional || return 1}
    [[ -n "$arg_status" ]] && {_rem_status || return 1}
}

# MARK: helpers ----------------------------------------------------------------

function _rem_is_mounted() {
    mount | grep -e fuse-t -e "$_rem_mnt_path" &>/dev/null
}

# MARK: functions called by main -----------------------------------------------

function _rem_unmount() {
    umount "$_rem_mnt_path"
}

function _rem_mount() {
    _rem_is_mounted && return 0
    mkdir -p "$_rem_mnt_path"
    sshfs \
        -o allow_other,default_permissions,compression=yes,cache=yes,auto_cache,reconnect,ServerAliveInterval=15,ServerAliveCountMax=3 \
        "$_rem_remote:" \
        "$_rem_mnt_path"
}

function _rem_mount_cd() {
    cd "$_rem_mnt_path"
}

function _rem_ssh() {
    local cwd="$(realpath .)"
    local rem_cwd='$HOME'
    if [[ "$(realpath .)" = "$_rem_mnt_path"* ]]; then
        rem_cwd="$(sed "s|^$_rem_mnt_path|\$HOME|" <<< "$cwd")"
    fi

    if [[ "$#" -eq 0 ]]; then
        kitten ssh --kitten cwd="$rem_cwd" "$_rem_remote"
        return 0
    fi

    local cmd="cd $rem_cwd; source ~/.bashrc; "
    local parg
    for parg ("$@"); do
        cmd+="$parg; "
    done

    ssh "$_rem_remote" "$cmd"
}

function _rem_status() {
    printf "mount: "
    _rem_is_mounted && echo "mounted" || echo "not mounted"
}
