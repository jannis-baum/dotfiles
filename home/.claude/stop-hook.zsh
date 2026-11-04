# stop hook: append Claude's last reply to the session scratchpad and show it with viv

input=$(cat)

dir=$(jq -r '.scratchpad_dir // empty' <<< "$input")
file="${dir:-$HOME/.cache}/reply.md"
msg=$(jq -r '.last_assistant_message // empty' <<< "$input")
# true when Claude continues after this hook blocked, its message is then only a follow up to the real reply
active=$(jq -r '.stop_hook_active // false' <<< "$input")

if [[ $active == true ]]; then
    # refresh Vivify so it shows images created since the reply was written
    touch "$file"
elif [[ -n $msg ]]; then
    first=${msg%%$'\n'*}
    preview=${first[1,80]}
    preview=${${${preview//&/&amp;}//\</&lt;}//\>/&gt;}
    (( ${#first} > 80 )) && preview+=…
    timestamp=$(date '+%a, %b %e at %l:%M%p')
    new=$(
        # only the newest reply stays expanded, the class keeps us from touching <details> inside replies
        [[ -f $file ]] && sed 's/^<details open class="reply">$/<details class="reply">/' "$file"
        printf '<details open class="reply">\n<summary>%s: %s</summary>\n\n%s\n\n</details>\n' \
            "$timestamp" "$preview" "$msg"
    )
    # write in place instead of sed -i, which swaps in a new file that Vivify's watcher never sees
    print -r -- "$new"$'\n' > "$file"
fi

viv "$file"

# make Claude create images it referenced but never wrote, once per stop so it can't loop
[[ $active == true ]] && exit 0
missing=()
for ref in ${(f)"$(grep -oE '!\[[^]]*\]\([^)]+\)' <<< "$msg")"}; do
    src=${${${ref#*\(}%\)}%% *}
    [[ $src == *://* || $src == data:* ]] && continue
    [[ $src == /* ]] || src="${file:h}/$src"
    [[ -e $src ]] || missing+=("$src")
done
if (( $#missing )); then
    print -l "Your reply references images that don't exist. Create and check them, or ignore this if they were only code examples." $missing >&2
    exit 2
fi
