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

    printf '%b%b%s%b' \
        "$color" \
        "$BOLD" \
        "$text" \
        "$RESET"
}


# ============================================================
# Git
# ============================================================

prompt_git() {
    local branch git_status upstream counts
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
    git_status=$(git status --porcelain 2>/dev/null)

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
    [[ -n "$git_status" ]] && info+=" ✦"

    # Remote status
    (( ahead > 0 ))  && info+=" ↑${ahead}"
    (( behind > 0 )) && info+=" ↓${behind}"

    # Color
    if [[ -n "$git_status" ]]; then
        segment "$FG_YELLOW" " ${info} "
    else
        segment "$FG_GREEN" " ${info} "
    fi
}

# ============================================================
# Prompt
# ============================================================
prompt_command() {
    PS1="$(segment "$FG_BLUE" '\u@\h')$(prompt_git)$(segment "$FG_GRAY" ' \w ')
❯ "
}

# ============================================================
# Hook
# ============================================================
PROMPT_COMMAND=prompt_command
