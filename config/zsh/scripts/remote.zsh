_rem_remote="hpc"
_rem_mnt_path="$HOME/_/hpi/hpc"
_rem_openvpn_config="SC_User"

# MARK: main function ----------------------------------------------------------

function rem() {
    # arugment parsing from
    # https://gist.github.com/jannis-baum/d3e5744466057f4e61614744a2397fdd
    local arg_help arg_unmount arg_disconnect arg_connect arg_mount arg_cd arg_status positional=()

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
                        "d") arg_disconnect=1;;
                        "c") arg_connect=1;;
                        "m") arg_mount=1;;
                        "w") arg_cd=1;;
                        "s") arg_status=1;;
                        *) _echo_error "Unknown option: -$opt";;
                    esac
                done
                continue;;
            "--help") arg_help=1; continue;;
            "--unmount") arg_unmount=1; continue;;
            "--disconnect") arg_disconnect=1; continue;;
            "--connect") arg_connect=1; continue;;
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

remote workflow with SSHFS and Tunnelblick, positional (or no) arguments act
like ssh. if in mount directory, ssh directory is translated to remote.

options ():
  -h, --help         print this message and exit
  -u, --unmount      unmount remote home
  -d, --disconnect   disconnect VPN
  -c, --connect      connect VPN
  -m, --mount        mount remote home
  -w, --cd           change to mount directory (set [w]orking directory)
  -s, --status       get mount information

short options can be combined, e.g. \`-cm\`, and will be executed in the order
above. execution stops if one option returns non-zero
EOF
        return
    fi

    [[ -n "$arg_unmount" ]] && {_rem_unmount || return 1}
    [[ -n "$arg_disconnect" ]] && {_rem_disconnect || return 1}
    [[ -n "$arg_connect" ]] && {_rem_connect || return 1}
    [[ -n "$arg_mount" ]] &&  {_rem_mount || return 1}
    [[ -n "$arg_cd" ]] && {_rem_cd || return 1}
    [[ -n "$arg_status" ]] && {_rem_status || return 1}

    [[ (
        -z "$arg_unmount" && \
        -z "$arg_disconnect" && \
        -z "$arg_connect" && \
        -z "$arg_mount" && \
        -z "$arg_cd" && \
        -z "$arg_status" \
    ) || -n "$positional" ]] && {_rem_ssh $positional || return 1}
}

# MARK: helpers ----------------------------------------------------------------

function _rem_is_mounted() {
    mount | grep -e fuse-t -e "$_rem_mnt_path" &>/dev/null
}

function _rem_is_connected() {
    local state="$(osascript -e 'tell application "Tunnelblick" to get state of configurations')"
    case "$state" in
        "CONNECTED") return 0;;
        "EXITING") return 1;;
        *) return 2;;
    esac
}

function _rem_wait_connection() {
    while true; do
        _rem_is_connected
        [[ "$?" == "$1" ]] && break
        sleep 0.3
    done
}

# MARK: functions called by main -----------------------------------------------

function _rem_unmount() {
    umount "$_rem_mnt_path"
}

function _rem_disconnect() {
    if _rem_is_mounted; then
        _rem_unmount > /dev/null || return 1
    fi
    osascript -e 'tell application "Tunnelblick" to disconnect all' &> /dev/null
    _rem_wait_connection 1
}

function _rem_connect() {
    osascript -e "tell application \"Tunnelblick\" to connect \"$_rem_openvpn_config\"" &> /dev/null
    _rem_wait_connection 0
}

function _rem_mount() {
    _rem_is_mounted && return 0
    mkdir -p "$_rem_mnt_path"
    sshfs \
        -o allow_other,default_permissions,compression=yes,cache=yes,auto_cache,reconnect,ServerAliveInterval=15,ServerAliveCountMax=3 \
        "$_rem_remote:" \
        "$_rem_mnt_path"
}

function _rem_cd() {
    cd "$_rem_mnt_path"
}

function _rem_ssh() {
    local cwd="$(realpath .)"
    local rem_cwd='~'
    if [[ "$(realpath .)" = "$_rem_mnt_path"* ]]; then
        rem_cwd="$(sed "s|^$_rem_mnt_path|\$HOME|" <<< "$cwd")"
    fi

    if [[ "$#" -eq 0 ]]; then
        kitten ssh --kitten cwd="$rem_cwd" "$_rem_remote"
        return 0
    fi

    local cmd=(cd "$rem_cwd" ';' source '~/.bashrc' ';')
    local parg
    for parg ("$@"); do
        cmd+=("${(q)parg}")
    done

    ssh "$_rem_remote" "${cmd[@]}"
}

function _rem_status() {
    printf "vpn: "
    _rem_is_connected
    case "$?" in
        0) echo "connected";;
        1) echo "not connected";;
        *) echo "unknown";;
    esac

    printf "mount: "
    _rem_is_mounted && echo "mounted" || echo "not mounted"
}
