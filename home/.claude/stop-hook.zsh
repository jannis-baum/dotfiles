# stop hook: write Claude's last reply to the session scratchpad and show it with viv

input=$(cat)

dir=$(jq -r '.scratchpad_dir // empty' <<< "$input")
file="${dir:-$HOME/.cache}/reply.md"

jq -r '.last_assistant_message // empty' <<< "$input" > "$file"
viv "$file"
