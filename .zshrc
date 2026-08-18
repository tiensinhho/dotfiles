# source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
# source /usr/local/opt/zsh-fast-syntax-highlighting/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh

# ============================================================
# Colors
# ============================================================

RESET='%f%k%b'
BOLD='%B'
DIM='%F{8}'

# Foreground
FG_BLUE='%F{25}'
FG_GREEN='%F{28}'
FG_GRAY='%F{240}'
FG_YELLOW='%F{136}'
FG_RED='%F{196}'

# Background
BG_BLUE='%K{25}'
BG_GREEN='%K{28}'
BG_GRAY='%K{240}'
BG_YELLOW='%K{136}'
BG_RED='%K{196}'


# ============================================================
# Segment
# ============================================================

segment() {
    local bg="$1"
    local text="$2"

    print -Pn "${bg} ${BOLD}${text}%b ${RESET}"
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
            ahead=${counts%%	*}
            behind=${counts##*	}
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

preexec() {
    PROMPT_START_TIME=$SECONDS
}

prompt_duration() {

    [[ -z "$PROMPT_START_TIME" ]] && return

    local duration=$((SECONDS - PROMPT_START_TIME))

    # Only show duration when command took >= 2 seconds
    if (( duration >= 2 )); then
        segment "$BG_GRAY" "⏱ ${duration}s"
    fi

    PROMPT_START_TIME=""
}


# ============================================================
# Exit status
# ============================================================

prompt_precmd() {

    local code=$?

    PROMPT_STATUS=""

    if (( code != 0 )); then
        PROMPT_STATUS="$(segment "$BG_RED" "✘ ${code}")"
    fi
}


# ============================================================
# Hooks
# ============================================================

autoload -Uz add-zsh-hook

add-zsh-hook precmd prompt_precmd
add-zsh-hook precmd prompt_duration


# ============================================================
# Prompt
# ============================================================

setopt PROMPT_SUBST

PROMPT='
${FG_BLUE}%F{255}$(segment "$BG_BLUE"  "%n@%m")$(prompt_git)$(prompt_duration)${PROMPT_STATUS}$(segment "$BG_GRAY" "%~")${FG_GRAY}
❯ '
