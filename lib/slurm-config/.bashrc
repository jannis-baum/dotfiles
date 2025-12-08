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

export PATH="$HOME/_/repo/tools/bin:$PATH"
export EDITOR=vim

# theme
export LS_COLORS="fi=1;38;5;242:di=3;38;5;246:ex=4;38;5;182"
PS1="\e[2m\h:\w\e[22m\n\[\e[38;5;210m\]\e[38;5;240;48;5;210m\]✻\[\e[0;38;5;210m\]\[\e[0m\] » "

# auto add ssh key
function setup_ssh_key() {
    local ssh_key="$HOME/.ssh/id_ed25519_github"
    if ! ssh-add "$ssh_key"; then
        eval "$(ssh-agent -s)" && ssh-add "$ssh_key"
    fi
}
setup_ssh_key &>/dev/null
unset -f setup_ssh_key

# SLURM-related things
cluster_addr="hpc.sci.hpi.de"
slurm_account="sci-renard-student"

alias sme="squeue --me"

function stop() {
    # arg parsing
    local arg_help arg_smi job_id
    while (( $# )); do
        _echo_error() {
            echo "$1" >&2
            arg_help=1; break
        }
        local arg="$1"; shift

        case "$arg" in
            "-h" | "--help") arg_help=1; continue;;
            "-s" | "--smi") arg_smi=1; continue;;
        esac

        [[ "$arg" == "-"* ]] && _echo_error "Unknown option: $arg"
        [[ -n "$job_id" ]] && _echo_error "Too many positional arguments"
        job_id="$arg"
    done
    which _echo_error >/dev/null && unfunction _echo_error

    if [[ -n "$arg_help" ]]; then
        cat <<EOF
usage: stop [job] [-s, --smi]

Watch research usage of given job or only running job.

optional positional arugments:
  job                    Job ID

options:
  -h, --help             Show this help message and exit.
  -s, --smi              Watch nvidia-smi instead of top
EOF
        return
    fi

    if [[ -z "$job_id" ]]; then
        local user_jobs="$(squeue --noheader --user $USER --states=running --format %A)"
        if [[ -z "$user_jobs" ]]; then
            echo "No job running" >&2
            return 1
        fi
        if [[ $(wc -l <<<"$user_jobs") -gt 1 ]]; then
            echo "Multiple jobs running, please specify one" >&2
            sme
            return 1
        fi
        job_id="$user_jobs"
    fi

    if [[ -n "$arg_smi" ]]; then
        srun --jobid="$job_id" -- watch --interval 1 nvidia-smi
    else
        # c to preserve stuff before top
        c
        srun --jobid="$job_id" --pty -- top -u $USER
        # actual clear to remove stop leftovers
        clear
    fi
}

function _prepare_template() {
    local temp_job="$(mktemp)"
    cat > "$temp_job"

    if ! vim "$temp_job" < /dev/tty >/dev/tty; then
        echo "Cancelled" 1>&2
        rm "$temp_job"
        return 1
    fi

    if [[ $1 == "--tty" ]]; then
        shift 1
        $@ "$temp_job" </dev/tty >/dev/tty
    else
        $@ "$temp_job"
    fi
    rm "$temp_job"
}
_template_dir="$HOME/slurm-templates"

function gpu() {
    {
        cat "$_template_dir/srun-header"
        cat "$_template_dir/srun-bionemo"
        cat "$_template_dir/srun-container"
        cat <<EOF
    --partition=gpu-interactive \\
    --cpus-per-task=32 \\
    --mem=128G \\
    --gpus=1 \\
    --constraint=ARCH:X86 \\
    --pty bash
EOF
    } | _prepare_template --tty source
}

function cpu() {
    {
        cat "$_template_dir/srun-header"
        cat "$_template_dir/srun-mmseq2"
        cat "$_template_dir/srun-container"
        cat <<EOF
    --partition=cpu-interactive \\
    --cpus-per-task=4 \\
    --mem=8G \\
    --pty bash
EOF
    } | _prepare_template --tty source
}

function sb() {
    {
        cat "$_template_dir/sbatch-header"
        cat <<EOF
#SBATCH --job-name=generic
#SBATCH --output=$HOME/.cache/generic-logs/%j
#SBATCH --error=$HOME/.cache/generic-logs/%j

EOF
        cat "$_template_dir/sbatch-bionemo"
        cat "$_template_dir/sbatch-mmseq2"
        cat "$_template_dir/sbatch-container"
        cat "$_template_dir/sbatch-resources"
        cat <<EOF

cd $(pwd -P)
EOF
    } | _prepare_template sbatch
}

function sjupyviv() {
    local logs_dir="$HOME/.cache/jupyviv/logs"
    mkdir -p "$logs_dir"

    local output="$({
        cat "$_template_dir/sbatch-header"
        cat <<EOF
#SBATCH --job-name=jupyviv
#SBATCH --output=$logs_dir/%j
#SBATCH --error=$logs_dir/%j

EOF
        cat "$_template_dir/sbatch-bionemo"
        cat "$_template_dir/sbatch-mmseq2"
        cat "$_template_dir/sbatch-container"
        cat "$_template_dir/sbatch-resources"
        cat <<EOF

cd $(pwd -P)
uv run jupyviv --log INFO agent python
EOF
    } | _prepare_template sbatch)"
    [[ $? -eq 0 ]] || return 1

    local job_id=$(echo "$output" | awk '{print $4}')
    echo "Submitted job $job_id. Waiting for it to start..."
    while true; do
        state="$(squeue --job "$job_id" --noheader --format "%T")"
        if [[ "$state" == "RUNNING" ]]; then
            node=$(squeue --job "$job_id" --noheader --format "%N")
            echo "Job $job_id is running on node $node"
            echo ""
            echo "Run the following to set up the SSH tunnel:"
            echo ""
            echo "ssh $USER@$node.$cluster_addr -N -L 31623:localhost:31623"
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
