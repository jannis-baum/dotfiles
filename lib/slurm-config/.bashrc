# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# generic aliases
alias s="ls --almost-all --color=always --group-directories-first"
alias l="s -l"
alias d="cd"
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias c="printf '\n%.0s' {2..$LINES} && clear"
alias g="git status"

# options & key bindings
set -o vi
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
bind -m vi-command '"k": history-search-backward'
bind -m vi-command '"j": history-search-forward'

# theme
export LS_COLORS="fi=1;38;5;242:di=3;38;5;246:ex=4;38;5;182"
PS1="\[\e[38;5;210m\]\e[38;5;240;48;5;210m\]✻\[\e[0;38;5;210m\]\[\e[0m\] \h:\w » "

# SLURM-related things
cluster_addr="hpc.sci.hpi.de"
slurm_account="sci-renard-student"

alias sme="squeue --me"

function _prepare_template() {
    temp_job="$(mktemp)"
    cat > "$temp_job"

    if ! vim "$temp_job" < /dev/tty >/dev/tty; then
        echo "Cancelled" 1>&2
        rm "$temp_job"
        return 1
    fi

    $@ "$temp_job"
    rm "$temp_job"
}
_template_dir="$HOME/slurm-templates"

function gpu() {
    {
        cat "$_template_dir/srun-header"
        cat "$_template_dir/srun-bionemo"
        cat <<EOF
    --partition=gpu-interactive \\
    --cpus-per-task=40 \\
    --mem=80G \\
    --gpus=1 \\
    --nodelist=gx \\
    --pty bash
EOF
    } | _prepare_template source
}

function cpu() {
    {
        cat "$_template_dir/srun-header"
        cat <<EOF
    --partition=cpu-interactive \\
    --cpus-per-task=40 \\
    --mem=80G \\
    --pty bash
EOF
    } | _prepare_template source
}

function sbgeneric() {
    temp_job="$(mktemp)"
    cat <<EOF > "$temp_job"
#!/bin/bash -ex

# MARK: leave as is
#SBATCH --account=sci-renard-student
#SBATCH --job-name=generic

# MARK: uncomment for bionemo
# #SBATCH --container-writable
# #SBATCH --container-name=bionemo
# #SBATCH --container-mount-home
# #SBATCH --gpus=1

# MARK: optional specification
# #SBATCH --nodelist=
#SBATCH --time=24:00:00
#SBATCH --partition=cpu
#SBATCH --output=/dev/null
#SBATCH --error=/dev/null
#SBATCH --cpus-per-task=32
#SBATCH --mem=128G

# MARK: script
EOF

    if ! vim "$temp_job"; then
        echo "Cancelled" 1>&2
        return 1
    fi
    sbatch "$temp_job"
    rm "$temp_job"
}

function sjupyviv() {
    if ! uv run jupyviv --help &>/dev/null; then
        echo "Jupyviv not found" 1>&2
        return 1
    fi
    logs_dir="$HOME/.cache/jupyviv/logs"
    mkdir -p "$logs_dir"

    temp_job="$(mktemp)"
    cat <<EOF > "$temp_job"
#!/bin/bash

# MARK: leave as is
#SBATCH --account=sci-renard-student
#SBATCH --job-name=jupyviv
#SBATCH --time=24:00:00
#SBATCH --output=$logs_dir/%j
#SBATCH --error=$logs_dir/%j

# MARK: uncomment for bionemo
# #SBATCH --container-writable
# #SBATCH --container-name=bionemo
# #SBATCH --container-mount-home
# #SBATCH --gpus=1

# MARK: optional specification
# #SBATCH --nodelist=
#SBATCH --cpus-per-task=32
#SBATCH --mem=128G
#SBATCH --partition=cpu

uv run jupyviv --log INFO agent python
EOF

    if ! vim "$temp_job"; then
        echo "Cancelled" 1>&2
        return 1
    fi
    job_id=$(sbatch "$temp_job" | awk '{print $4}')
    rm "$temp_job"

    echo "Submitted job $job_id. Waiting for it to start..."
    while true; do
        state="$(squeue --job "$job_id" --noheader --format "%T")"
        if [[ "$state" == "RUNNING" ]]; then
            node=$(squeue --job "$job_id" --noheader --format "%N")
            echo "Job $job_id is running on node $node"
            echo ""
            echo "Run the following to set up the SSH tunnel:"
            echo ""
            echo "ssh $USER@$node.$cluster_addr -N -L 8000:localhost:8000"
            break
        fi
    done
}

# misc
function ensure-jupyviv() {
    source .venv/bin/activate \
        && python -m ensurepip \
        && python -m pip install git+https://github.com/jannis-baum/Jupyviv.git ipykernel
}
