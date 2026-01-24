_rem_remote="hpc"
_rem_mnt_path="$HOME/_/hpi/hpc"

function rem() {
    # MARK: ARUGMENT PARSING ---------------------------------------------------
    # from https://gist.github.com/jannis-baum/d3e5744466057f4e61614744a2397fdd
    local arg_help="" func="_rem_ssh" positional=()

    while (( $# )); do
        _echo_error() {
            echo "$1" >&2
            arg_help=1; break
        }
        local arg="$1"; shift

        case "$arg" in
            "-h" | "--help") arg_help=1; continue;;
            "-m" | "--mount") func="_rem_mount"; continue;;
            "-md" | "--mount-cd") func="_rem_mount_cd"; continue;;
            "-u" | "--unmount") func="_rem_unmount"; continue;;
        esac

        [[ "$arg" == "-"* ]] && _echo_error "Unknown option: $arg"
        positional+=("$arg")
    done
    which _echo_error >/dev/null && unfunction _echo_error
    # MARK: ARUGMENT PARSING done ----------------------------------------------

    if [[ -n "$arg_help" ]]; then
        cat <<EOF
usage: rem [command [args]]

SSHFS-focussed remote workflow, acts like \`ssh $_rem_remote\` without options

options
  -m, --mount        mount remote home
  -md, --mount-cd    mount remote home and change to mount directory
  -u, --unmount      unmount remote home
EOF
        return
    fi

    $func $positional
}

function _rem_is_mounted() {
    mount | grep -e fuse-t -e "$_rem_mnt_path" &>/dev/null
}

function _rem_mount() {
    if [[ "$#" -ne 0 ]]; then
        echo "Too many arguments, expected 0"
        return 1
    fi
    _rem_is_mounted && return 0
    mkdir -p "$_rem_mnt_path"
    sshfs \
        -o allow_other,default_permissions,compression=yes,cache=yes,auto_cache,reconnect,ServerAliveInterval=15,ServerAliveCountMax=3 \
        "$_rem_remote:" \
        "$_rem_mnt_path"
}

function _rem_mount_cd() {
    if [[ "$#" -ne 0 ]]; then
        echo "Too many arguments, expected 0"
        return 1
    fi
    _rem_mount
    cd "$_rem_mnt_path"
}

function _rem_unmount() {
    if [[ "$#" -ne 0 ]]; then
        echo "Too many arguments, expected 0"
        return 1
    fi
    umount "$_rem_mnt_path"
}

function _rem_ssh() {
    if [[ "$#" -eq 0 ]]; then
        ssh "$_rem_remote"
        return 0
    fi

    local cmd="cd; source ~/.bashrc; "
    local parg
    for parg ("$@"); do
        cmd+="$parg; "
    done

    ssh "$_rem_remote" "$cmd"
}
