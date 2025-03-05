alias synapse-list-repos="gh repo list --limit 1000 | rg synapse | cut -w -f1"

function synapse-set-project-token() {
    printf "Token: "
    local token
    read -s token
    printf "\n"
    for repo in $(synapse-list-repos); do
        echo "$token" | gh secret set --repo "$repo" ADD_TO_PROJECT_PAT
    done
}
