# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# explicitely expand aliases so they also work in non-interactive sessions that
# source this file. note that this option only takes effect from the next
# **line**, i.e. doing
#
#     source ~/.bashrc; shopt -s expand_aliases; <alias>
#
# doesn't work so it makes sense to just have it here.
# (https://stackoverflow.com/questions/1615877/why-aliases-in-a-non-interactive-bash-shell-do-not-work#comment65785947_1615973)
shopt -s expand_aliases

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

export PATH=\
"$HOME/.local/lib/kraken2:"\
"$HOME/.local/lib/ncbi-blast-2.17.0+/bin/:"\
"$HOME/.local/lib/meme/bin:"\
"$HOME/.local/lib/meme/libexec/meme-5.5.9:"\
"$PATH"

export EDITOR=vim

# theme
export LS_COLORS="fi=1;38;5;242:di=3;38;5;246:ex=4;38;5;182"
PS1="\[\e[2m\]\h:\w\[\e[22m\]\n\
\[\e[38;5;210m\]\[\e[38;5;240;48;5;210m\]✻\[\e[0;38;5;210m\]\
\[\e[0m\] » "

# auto add ssh key
function _setup_ssh_key() {
    if [[ -z "$SSH_AGENT_PID" ]] || ! ps -p $SSH_AGENT_PID; then
        eval "$(ssh-agent -s)"
    fi
    ssh-add "$HOME/.ssh/id_ed25519_github"
}
_setup_ssh_key &>/dev/null
unset -f _setup_ssh_key

# SLURM-related things
cluster_addr="hpc.sci.hpi.de"
slurm_account="sci-renard-student"

function sme() {
    local output="$(\squeue --format "%.8i %.9P %.20j %.10M %.2t %4C %5m %.20R %.16b" --me)"
    echo -e "\e[1;4m$(head -1 <<< "$output" | sed -e "s/TRES_PER_NODE/    RESOURCES/" -e "s/MIN_M/MEM  /")\e[0m"
    tail -n +2 <<< "$output"
}

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

    # srun --overlap allows it to share resources with running steps (necessary
    # if job was started with srun where it's just one step rather than
    # sbatch/salloc)
    if [[ -n "$arg_smi" ]]; then
        srun --overlap --jobid="$job_id" -- watch --interval 1 nvidia-smi
    else
        # c to preserve stuff before top
        c
        srun --overlap --jobid="$job_id" --pty -- top -u $USER
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
function _get_template() {
    local template_path="$HOME/slurm-templates/$1"
    if ! test -f "$template_path"; then
        echo "file not found: $template_path" >&2
        return 1
    fi

    if [[ "$2" == "srun" ]]; then
        cat "$template_path" | sed "s/#SBATCH //"
    else
        cat "$template_path"
    fi
}

function gpu() {
    local tmpfile="$(mktemp)"
    echo "_srun_args=(" > "$tmpfile"
    cat <<EOF | _prepare_template cat >> "$tmpfile"
# srun args
$(_get_template header srun)
$(_get_template bionemo srun)
$(_get_template container srun)
--partition=gpu-interactive
--cpus-per-task=32
--mem=128G
--gpus=1
--constraint=ARCH:X86
--pty bash
EOF
    if [[ $? -ne 0 ]]; then
        return 1
        rm "$tmpfile"
    fi
    cat <<EOF >> "$tmpfile"
)
srun "\${_srun_args[@]}"
unset _srun_args
EOF

    source "$tmpfile"
    rm "$tmpfile"
}

function cpu() {
    local tmpfile="$(mktemp)"
    echo "_srun_args=(" > "$tmpfile"
    cat <<EOF | _prepare_template cat >> "$tmpfile"
# srun args
$(_get_template header srun)
$(_get_template mmseq2 srun)
$(_get_template container srun)
--partition=cpu-interactive
--cpus-per-task=4
--mem=8G
--pty bash
EOF
    if [[ $? -ne 0 ]]; then
        return 1
        rm "$tmpfile"
    fi
    cat <<EOF >> "$tmpfile"
)
srun "\${_srun_args[@]}"
unset _srun_args
EOF

    source "$tmpfile"
    rm "$tmpfile"
}

function sb() {
    {
        cat <<EOF
#!/bin/bash -ex
$(_get_template header)
#SBATCH --job-name=generic
#SBATCH --output=$HOME/.cache/generic-logs/%j
#SBATCH --error=$HOME/.cache/generic-logs/%j

$(_get_template bionemo)
$(_get_template mmseq2)
$(_get_template container)
$(_get_template resources)

export PYTHONUNBUFFERED=1
cd $(pwd -P)
EOF
    } | _prepare_template sbatch
}

function sjupyviv() {
    local logs_dir="$HOME/.cache/jupyviv/logs"
    mkdir -p "$logs_dir"

    local output="$({
        cat <<EOF
#!/bin/bash -ex
$(_get_template header)
#SBATCH --job-name=jupyviv
#SBATCH --output=$logs_dir/%j
#SBATCH --error=$logs_dir/%j

$(_get_template bionemo)
$(_get_template mmseq2)
$(_get_template container)
$(_get_template resources)

export PYTHONUNBUFFERED=1
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

function share-permissions() {
    local target_dir="$1"
    [[ -z "$target_dir" ]] && target_dir="."

    # files: everyone reads, owner writes
    find "$target_dir" -type f -exec chmod 644 {} \;
    # directories: everyone reads and executes, owner writes
    find "$target_dir" -type d -exec chmod 755 {} \;
}

function storage() {
    function _usage() {
        echo "usage: storage [-u | --update] [-d | --date]" >&2
        unset -f _usage
        return 1
    }
    [[ "$#" -gt 1 ]] && _usage

    local ncdu_output="$HOME/.cache/ncdu_output.json"

    case "$1" in
        "-u" | "--update")
        sbatch <<EOF
#!/bin/bash -ex

#SBATCH --account=sci-renard-student
#SBATCH --time=24:00:00
#SBATCH --job-name=ncdu-storage-map
#SBATCH --output=/dev/null
#SBATCH --error=/dev/null

# MARK: resources
#SBATCH --partition=cpu-batch
#SBATCH --cpus-per-task=2
#SBATCH --mem=2G

cd
ncdu -1xo $ncdu_output
EOF
            ;;
        "-d" | "--date") stat --format=%y "$ncdu_output";;
        "")
            read -p "latest storage map from $(stat --format=%y "$ncdu_output"). press return to view"
            ncdu -f "$ncdu_output"
            ;;
        *) _usage;;
    esac
}
