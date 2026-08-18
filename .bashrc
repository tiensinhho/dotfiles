# ============================================================
# Colors
# ============================================================

RESET='\[\e[0m\]'
BOLD='\[\e[1m\]'
DIM='\[\e[38;5;240m\]'

# Foreground
FG_BLUE='\[\e[38;5;25m\]'
FG_GRAY='\[\e[38;5;240m\]'

# Background
BG_BLUE='\[\e[48;5;25m\]'
BG_GREEN='\[\e[48;5;28m\]'
BG_GRAY='\[\e[48;5;240m\]'
BG_YELLOW='\[\e[48;5;136m\]'
BG_RED='\[\e[48;5;196m\]'


# ============================================================
# Segment
# ============================================================

segment() {
    local bg="$1"
    local text="$2"

    printf '%b%b %s %b%b' \
        "$bg" "$BOLD" "$text" "$RESET" "$RESET"
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

    local info=" ${branch}"

    # Dirty working tree
    [[ -n "$status" ]] && info+=" ✦"

    # Remote status
    (( ahead > 0 ))  && info+=" ⇡${ahead}"
    (( behind > 0 )) && info+=" ⇣${behind}"

    # Color
    if [[ -n "$status" ]]; then
        segment "$BG_YELLOW" "$info"
    else
        segment "$BG_GREEN" "$info"
    fi
}


# ============================================================
# Command duration
# ============================================================

PROMPT_START_TIME=0

# Bash equivalent of zsh preexec
trap 'PROMPT_START_TIME=$SECONDS' DEBUG

prompt_duration() {
    [[ "$PROMPT_START_TIME" -eq 0 ]] && return

    local duration=$((SECONDS - PROMPT_START_TIME))

    if (( duration >= 2 )); then
        segment "$BG_GRAY" "⏱ ${duration}s"
    fi

    PROMPT_START_TIME=0
}


# ============================================================
# Exit status
# ============================================================

prompt_status() {
    local code=$?

    PROMPT_STATUS=""

    if (( code != 0 )); then
        PROMPT_STATUS=$(segment "$BG_RED" "✘ ${code}")
    fi
}


# ============================================================
# Prompt
# ============================================================

prompt_command() {
    local cwd git duration status

    # Save previous command exit status
    local code=$?

    # Status
    PROMPT_STATUS=""

    if (( code != 0 )); then
        PROMPT_STATUS=$(segment "$BG_RED" "✘ ${code}")
    fi

    # Duration
    duration=""
    if [[ "$PROMPT_START_TIME" -ne 0 ]]; then
        local elapsed=$((SECONDS - PROMPT_START_TIME))

        if (( elapsed >= 2 )); then
            duration=$(segment "$BG_GRAY" "⏱ ${elapsed}s")
        fi
    fi

    PROMPT_START_TIME=0

    # Git
    git=$(prompt_git)

    # Current directory
    cwd=$(segment "$BG_GRAY" '\w')

    # Prompt
    PS1="${FG_BLUE}$(segment "$BG_BLUE" '\u@\h')${git}${duration}${PROMPT_STATUS}${cwd}${FG_GRAY}
❯ "
}

PROMPT_COMMAND=prompt_command
