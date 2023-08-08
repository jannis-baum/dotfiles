function _color_component() {
    bc <<< "ibase=16; $(tr '[:lower:]' '[:upper:]' <<< $1)"
}

function show-color() {
    if [[ ${#1} -eq 6 ]]; then
        local r=$(_color_component ${1:0:2})
        local g=$(_color_component ${1:2:2})
        local b=$(_color_component ${1:4:2})
    elif [[ ${#1} -eq 3 ]]; then
        local r=${1:0:1}; r=$(_color_component "$r$r")
        local g=${1:1:1}; g=$(_color_component "$g$g")
        local b=${1:2:1}; b=$(_color_component "$b$b")
    else
        echo "hex color should be 3 or 6 characters."
        return 1
    fi

    printf "\e[48;2;$r;$g;${b}m"
    for row in {1..8}; do
        printf ' %.0s' {1..32}
        printf "\n"
    done
    printf "\e[0m"
}
