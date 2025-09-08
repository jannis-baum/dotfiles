_sio_papers_path="$(realpath "$HOME/_/icloud/papers")"
_sio_app_path="/Applications/sioyek.app/Contents/MacOS/sioyek"

function _sio_running() {
    [[ -n "$(grep "$_sio_app_path" <<< "$(ps aux)")" ]]
}

# lazily launch sioyek PDF viewer
function sioyek() {
    while ! _sio_running; do;
        if [[ -z "$_launched_sioyek" ]]; then
            open -a sioyek
            local _launched_sioyek=1
        fi
    done
    "$_sio_app_path" "$@"
    return $?
}

function sio() {
    if [[ "$1" == "--get" ]]; then
        _sio_running || return 1
        local state="$(sioyek --execute-command get_state_json --wait-for-response --nofocus | tail -1)"
        local fp="$(jq --raw-output '.[0].document_path' <<< "$state" | sed "s|^$_sio_papers_path/||")"
        local page="$(jq --raw-output '.[0].page_number' <<< "$state")"
        local ruler="$(jq --raw-output '.[0].ruler_index' <<< "$state")"
        echo "$fp $page $ruler"
        return 0
    fi
}
