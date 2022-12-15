function _color_component() {
    bc <<< "ibase=16; $(tr '[:lower:]' '[:upper:]' <<< ${1:$2:$3})"
}

function show-color() {
    if [[ ${#1} -ne 6 ]]; then
        echo "hex color should be 6 characters"
    fi

    local r=$(_color_component $1 0 2)
    local g=$(_color_component $1 2 2)
    local b=$(_color_component $1 4 2)

    printf "\e[48;2;$r;$g;${b}m"
    for row in {1..8}; do
        printf ' %.0s' {1..32}
        printf "\n"
    done
    printf "\e[0m"
}
