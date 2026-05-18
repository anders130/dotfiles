#!/usr/bin/env bash
input=$(cat)

C_RESET='\033[0m'
C_DIM='\033[2m'
C_CYAN='\033[36m'
C_BLUE='\033[34m'
C_YELLOW='\033[33m'
C_MAGENTA='\033[35m'
C_WHITE='\033[37m'
C_GREEN='\033[32m'
C_RED='\033[31m'
C_SEP='\033[2;37m'
SEP="${C_SEP}|${C_RESET}"

model_name=""
model_display=""
ctx_display=""
tok_display=""
branch_display=""
dir_display=""
five_pct=""
week_pct=""
cwd=""
git_branch=""

if [ "$SHOW_MODEL" = "true" ]; then
    model_name=$(echo "$input" | jq -r '.model.display_name // "Claude"')
    ctx_size=$(echo "$input" | jq -r '.context_window.context_window_size // 0')
fi

if [ "$SHOW_CONTEXT_BAR" = "true" ]; then
    used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
fi

if [ "$SHOW_TOKENS" = "true" ]; then
    total_in=$(echo "$input" | jq -r '.context_window.total_input_tokens // 0')
    total_out=$(echo "$input" | jq -r '.context_window.total_output_tokens // 0')
fi

if [ "$SHOW_FIVE_HOUR" = "true" ]; then
    five_pct=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
    five_resets=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
fi

if [ "$SHOW_SEVEN_DAY" = "true" ]; then
    week_pct=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
    week_resets=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // empty')
fi

if [ "$SHOW_GIT_BRANCH" = "true" ] || [ "$SHOW_DIRECTORY" = "true" ]; then
    cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // ""')
    if [ -z "$cwd" ]; then
        cwd=$(pwd)
    fi
fi

if [ "$SHOW_GIT_BRANCH" = "true" ]; then
    git_branch=$(git -C "$cwd" --no-optional-locks symbolic-ref --short HEAD 2>/dev/null || true)
    if [ -n "$git_branch" ]; then
        branch_display="${C_MAGENTA}${git_branch}${C_RESET}"
    fi
fi

if [ "$SHOW_MODEL" = "true" ]; then
    if [ "$ctx_size" -ge 1000000 ] 2>/dev/null; then
        ctx_size_display=$(printf "%.0fM" "$(echo "$ctx_size" | awk '{printf "%.0f", $1/1000000}')")
    elif [ "$ctx_size" -ge 1000 ] 2>/dev/null; then
        ctx_size_display=$(printf "%dk" "$((ctx_size / 1000))")
    else
        ctx_size_display="${ctx_size}"
    fi
    model_display="${C_CYAN}${model_name}${C_DIM} (${ctx_size_display})${C_RESET}"
fi

if [ "$SHOW_CONTEXT_BAR" = "true" ]; then
    ctx_color="${C_GREEN}"
    if [ -n "${used_pct:-}" ]; then
        pct_int=$(echo "$used_pct" | awk '{printf "%d", int($1)}')
        if [ "$pct_int" -ge 90 ]; then
            ctx_color="${C_RED}"
        elif [ "$pct_int" -ge 70 ]; then
            ctx_color="${C_YELLOW}"
        fi
        filled=$(echo "$used_pct" | awk '{printf "%d", int($1 / 10 + 0.5)}')
        if [ "$filled" -gt 10 ]; then filled=10; fi
        empty=$((10 - filled))
        bar=""
        i=0
        while [ "$i" -lt "$filled" ]; do bar="${bar}▰"; i=$((i + 1)); done
        i=0
        while [ "$i" -lt "$empty" ]; do bar="${bar}▱"; i=$((i + 1)); done
        ctx_display="${ctx_color}[${bar}] $(printf "%.0f" "$used_pct")%${C_RESET}"
    else
        ctx_display="${C_GREEN}[▱▱▱▱▱▱▱▱▱▱] --%${C_RESET}"
    fi
fi

if [ "$SHOW_TOKENS" = "true" ]; then
    total_tokens=$((total_in + total_out))
    if [ "$total_tokens" -ge 1000000 ]; then
        tok_display=$(echo "$total_tokens" | awk '{printf "%.1fM Tok", $1/1000000}')
    elif [ "$total_tokens" -ge 1000 ]; then
        tok_display=$(printf "%dk Tok" "$((total_tokens / 1000))")
    else
        tok_display="${total_tokens} Tok"
    fi
    tok_display="${C_WHITE}${tok_display}${C_RESET}"
fi

if [ "$SHOW_FIVE_HOUR" = "true" ] || [ "$SHOW_SEVEN_DAY" = "true" ]; then
    format_reset() {
        resets_at="$1"
        is_weekly="$2"
        if [ -z "$resets_at" ]; then printf "%s" ""; return; fi
        now=$(date +%s)
        remaining=$((resets_at - now))
        if [ "$remaining" -le 0 ]; then printf "%s" "0h"; return; fi
        hours=$((remaining / 3600))
        days=$((remaining / 86400))
        if [ "$is_weekly" = "1" ] && [ "$days" -ge 1 ]; then
            printf "%s" "${days}d"
        else
            printf "%s" "${hours}h"
        fi
    }
fi

if [ "$SHOW_DIRECTORY" = "true" ]; then
    dir_name=$(basename "$cwd")
    parent_name=$(basename "$(dirname "$cwd")")
    dir_display="${parent_name}/${dir_name}"
fi

append() {
    seg="$1"
    if [ -n "$line" ]; then
        line="${line} ${SEP} ${seg}"
    else
        line="${seg}"
    fi
}

line=""
if [ "$SHOW_MODEL" = "true" ]; then append "${model_display}"; fi
if [ "$SHOW_CONTEXT_BAR" = "true" ]; then append "${ctx_display}"; fi
if [ "$SHOW_FIVE_HOUR" = "true" ] && [ -n "$five_pct" ]; then
    reset_str=$(format_reset "$five_resets" "0")
    append "${C_YELLOW}5h: $(printf "%.0f" "$five_pct")% (${reset_str})${C_RESET}"
fi
if [ "$SHOW_SEVEN_DAY" = "true" ] && [ -n "$week_pct" ]; then
    reset_str=$(format_reset "$week_resets" "1")
    append "${C_YELLOW}7d: $(printf "%.0f" "$week_pct")% (${reset_str})${C_RESET}"
fi
if [ "$SHOW_GIT_BRANCH" = "true" ] && [ -n "$git_branch" ]; then append "${branch_display}"; fi
if [ "$SHOW_DIRECTORY" = "true" ]; then append "${C_BLUE}${dir_display}${C_RESET}"; fi
if [ "$SHOW_TOKENS" = "true" ]; then append "${tok_display}"; fi

printf "%b" "$line"
