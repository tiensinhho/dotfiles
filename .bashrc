# ============================================================
# Colors
# ============================================================

RESET='\[\e[0m\]'
BOLD='\[\e[1m\]'

FG_BLUE='\[\e[34m\]'
FG_GREEN='\[\e[32m\]'
FG_GRAY='\[\e[90m\]'
FG_YELLOW='\[\e[33m\]'
FG_RED='\[\e[31m\]'


# ============================================================
# Variables
# ============================================================

PROMPT_START_TIME=0
PROMPT_STATUS=''


# ============================================================
# Segment
# ============================================================

segment() {
    local color="$1"
    local text="$2"

    printf '%b%b%s%b' "$color" "$BOLD" "$text" "$RESET"
}


# ============================================================
# Git
# ============================================================

prompt_git() {
    local branch status upstream counts
    local ahead=0
    local behind=0

    # Not a Git repository
    git rev-parse --is-inside-work-tree >/dev/null 2>&1 || return

    # Branch
    branch=$(git branch --show-current 2>/dev/null)

    # Detached HEAD
    if [[ -z "$branch" ]]; then
        branch=$(git rev-parse --short HEAD 2>/dev/null)
        branch="@${branch}"
    fi

    # Working tree status
    status=$(git status --porcelain 2>/dev/null)

    # Remote tracking branch
    upstream=$(git rev-parse --abbrev-ref '@{upstream}' 2>/dev/null)

    if [[ -n "$upstream" ]]; then
        counts=$(git rev-list --left-right --count HEAD..."$upstream" 2>/dev/null)

        if [[ -n "$counts" ]]; then
            read -r ahead behind <<< "$counts"
        fi
    fi

    local info="git:${branch}"

    # Dirty working tree
    [[ -n "$status" ]] && info+=" ✦"

    # Remote status
    (( ahead > 0 ))  && info+=" ↑${ahead}"
    (( behind > 0 )) && info+=" ↓${behind}"

    if [[ -n "$status" ]]; then
        segment "$FG_YELLOW" " ${info} "
    else
        segment "$FG_GREEN" " ${info} "
    fi
}


# ============================================================
# Command duration
# ============================================================

prompt_preexec() {
    PROMPT_START_TIME=$SECONDS
}

prompt_duration() {

    [[ "$PROMPT_START_TIME" -eq 0 ]] && return

    local duration=$((SECONDS - PROMPT_START_TIME))

    if (( duration >= 2 )); then
        segment "$FG_GRAY" " ${duration}s "
    fi

    PROMPT_START_TIME=0
}


# ============================================================
# Prompt status
# ============================================================

prompt_status() {

    local code=$1

    PROMPT_STATUS=''

    if (( code != 0 )); then
        PROMPT_STATUS=$(segment "$FG_RED" " ✘ ${code} ")
    fi
}


# ============================================================
# Build prompt
# ============================================================

prompt_command() {

    local exit_code=$?

    prompt_status "$exit_code"

    prompt_duration

    PS1="
$(segment "$FG_BLUE" '\u@\h')$(prompt_git)${PROMPT_STATUS}$(segment "$FG_GRAY" ' \w ')
❯ "

    prompt_preexec
}


# ============================================================
# Hooks
# ============================================================

PROMPT_COMMAND=prompt_command
