# stop hook: append Claude's last reply to the session scratchpad and show it with viv

input=$(cat)

dir=$(jq -r '.scratchpad_dir // empty' <<< "$input")
file="${dir:-$HOME/.cache}/reply.md"
msg=$(jq -r '.last_assistant_message // empty' <<< "$input")

if [[ -n $msg ]]; then
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
