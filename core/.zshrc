# Adopted from simnalamburt/.dotfiles

# If not running interactively, don't do anything
[[ -o interactive ]] || return

# Disable undef
stty stop undef

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
typeset -g POWERLEVEL9K_INSTANT_PROMPT=off
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# WSL: Why do I need this?
umask 022

# GPG
export GPG_TTY=`tty`

# Chrome to Chromium
export CHROME_BIN="$(which chromium)"

#
# zinit (updated paths)
#
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
autoload -U is-at-least
if is-at-least 5.1 && [ -d "$ZINIT_HOME" ]; then
  source "${ZINIT_HOME}/zinit.zsh"
  autoload -Uz _zinit
  (( ${+_comps} )) && _comps[zinit]=_zinit

  zinit ice depth=1
  zinit light romkatv/powerlevel10k

  zinit light zsh-users/zsh-completions
  zinit light zdharma-continuum/fast-syntax-highlighting  # Updated
  zinit light zsh-users/zsh-autosuggestions              # Added
  zinit light simnalamburt/cgitc

  autoload -Uz compinit
  compinit
  zinit cdreplay
else
  PS1='%n@%m:%~%# '
  autoload -Uz compinit
  compinit
fi

#
# powerlevel10k
#
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

#
# Terminal title
#
precmd() {
  print -Pn "\e]0;%n@%m: %~\a"
}

#
# zsh-sensible
#
alias l='ls -lah'
alias mv='mv -i'
alias cp='cp -i'

setopt auto_cd histignorealldups sharehistory
zstyle ':completion:*' menu select

#
# lscolors
#
autoload -U colors && colors
export LSCOLORS="Gxfxcxdxbxegedxbagxcad"
export LS_COLORS="di=1;36:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=0;41:sg=30;46:tw=0;42:ow=30;43"
export TIME_STYLE='long-iso'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

#
# zsh-substring-completion
#
setopt complete_in_word
setopt always_to_end
WORDCHARS=''
zmodload -i zsh/complist

# Substring completion
zstyle ':completion:*' matcher-list 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

#
# zshrc
#

# typo alias
alias sl=ls
alias ㅣ=l
alias 니=ls
alias ㅣㄴ=ls
alias ㄴㅣ=ls

# Modern CLI tools (Rust-based, faster alternatives)
# grep → rg (53x faster, respects .gitignore)
alias grep='rg'
alias grepc='rg --context'

# cat → bat (syntax highlighting, line numbers, git diff)
alias cat='bat --paging=never --style=plain'
alias catn='bat --paging=never'  # with line numbers
alias catp='bat'  # with paging

# find → fd (68x faster, respects .gitignore)
# NOTE: fd has different syntax than find, so not aliased by default
# Use 'fd' directly instead:
#   find . -name "*.js"  →  fd "\.js$"
#   find . -type f       →  fd --type f
# alias find='fd'  # DISABLED: breaks existing find commands

# ls → eza (git status, colors, icons)
alias ls='eza'
alias ll='eza -l --git'
alias la='eza -la --git'
alias tree='eza --tree'

# Claude Parallel Session (tmux + Alacritty)
cps() {
  if [ -z "$1" ]; then
    echo "❌ Usage: cps <task-name>"
    echo "Example: cps auth-refactor"
    return 1
  fi

  # Create worktree
  ~/me/scripts/parallel-session.sh "$1" || return 1

  # Create new tmux window and start Claude
  if [ -n "$TMUX" ]; then
    # Already in tmux - create new window
    tmux new-window -n "$1" -c ~/me-wt-$1 "claude"
    echo "✅ New tmux window created: $1"
  else
    echo "⚠️  Not in tmux. Run manually:"
    echo "   cd ~/me-wt-$1 && claude"
  fi
}

# 4-Session Setup: Plan + 3 Parallel Sessions
cps4() {
  if [ -z "$1" ]; then
    echo "❌ Usage: cps4 <base-name>"
    echo "Example: cps4 feature"
    echo ""
    echo "Creates 4 tmux windows:"
    echo "  1. feature-plan    (Plan Mode)"
    echo "  2. feature-impl-1  (Implementation)"
    echo "  3. feature-impl-2  (Implementation)"
    echo "  4. feature-impl-3  (Implementation)"
    return 1
  fi

  if [ -z "$TMUX" ]; then
    echo "⚠️  Must be in tmux session!"
    return 1
  fi

  local base="$1"

  echo "🚀 Creating 4-session setup: $base"
  echo ""

  # Window 1: Plan Mode
  echo "📝 Creating: ${base}-plan (Plan Mode)"
  ~/me/scripts/parallel-session.sh "${base}-plan" || return 1
  tmux new-window -n "${base}-plan" -c ~/me-wt-${base}-plan "claude --permission-mode plan"

  # Window 2-4: Implementation
  for i in 1 2 3; do
    echo "💻 Creating: ${base}-impl-$i"
    ~/me/scripts/parallel-session.sh "${base}-impl-$i" || return 1
    tmux new-window -n "${base}-impl-$i" -c ~/me-wt-${base}-impl-$i "claude"
  done

  echo ""
  echo "✅ 4-session setup complete!"
  echo ""
  echo "Windows created:"
  echo "  Ctrl+b w  → See all windows"
  echo "  Ctrl+b 0  → Go to window 0 (original)"
  echo "  Ctrl+b 1  → ${base}-plan (Plan Mode)"
  echo "  Ctrl+b 2  → ${base}-impl-1"
  echo "  Ctrl+b 3  → ${base}-impl-2"
  echo "  Ctrl+b 4  → ${base}-impl-3"
}

# fzf
if [ -f ~/.fzf.zsh ]; then
  [ -z "$HISTFILE" ] && HISTFILE=$HOME/.zsh_history
  HISTSIZE=10000
  SAVEHIST=10000
  source ~/.fzf.zsh

  export FZF_COMPLETION_TRIGGER='\'

  # Use fd if available
  if hash fd 2>/dev/null; then
    export FZF_DEFAULT_COMMAND='fd --type f'

    _fzf_compgen_path() {
      fd --hidden --follow --exclude ".yarn" --exclude ".git" . "$1"
    }

    _fzf_compgen_dir() {
      fd --type d --hidden --exclude ".yarn" --follow --exclude ".git" . "$1"
    }
  fi

  if hash git 2>/dev/null; then
    gbfzf() {
      git branch | egrep -v '^\*' | sed -e 's/^ *//' | \
        fzf --ansi \
        --prompt='git branch> ' \
        --preview="git log --color=always --decorate --oneline --graph {1} | head -n $LINES"
    }

    gcoz() {
      local branch="$(gbfzf)"
      git checkout "$branch"
    }
  fi
fi

# tmux
if [ "$TMUX" = "" ]; then; export TERM="xterm-256color"; fi

# ~/.local/bin
if [ -d ~/.local/bin ]; then; export PATH="$HOME/.local/bin:$PATH"; fi
# ~/.local/lib
if [ -d ~/.local/lib ]; then; export LD_LIBRARY_PATH="$HOME/.local/lib:$LD_LIBRARY_PATH"; fi

# Ruby
if hash ruby 2>/dev/null && hash gem 2>/dev/null; then
  export GEM_HOME=$(ruby -e 'print Gem.user_dir')
  export PATH="$PATH:$GEM_HOME/bin"
fi

# Golang
if hash go 2>/dev/null; then
  export GOPATH=~/.go
  mkdir -p $GOPATH
  export PATH="$PATH:$GOPATH/bin"
fi

# cargo install
if [ -d ~/.cargo/bin ]; then
  export PATH="$PATH:$HOME/.cargo/bin"
fi

# yarn
if [ -d ~/.yarn ]; then
  export PATH="$PATH:$HOME/.yarn/bin"
fi

# yarn global
if hash yarn 2>/dev/null; then
  export PATH="$PATH:$HOME/.config/yarn/global/node_modules/.bin"
fi

# torch
if [ -d ~/torch/install ]; then
  export PATH="$HOME/torch/install/bin:$PATH"
  export LD_LIBRARY_PATH="$HOME/torch/install/lib:$LD_LIBRARY_PATH"
fi

# pyenv
if [ -d ~/.pyenv ]; then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$HOME/.pyenv/bin:$PATH"
fi
if hash pyenv 2>/dev/null; then
  eval "$(pyenv init -)"
  if hash pyenv-virtualenv-init 2>/dev/null; then
    eval "$(pyenv virtualenv-init -)"
  fi
fi

# nodenv
if [ -d ~/.nodenv ]; then
  export PATH="$HOME/.nodenv/bin:$PATH"
  eval "$(nodenv init -)"
fi

# open
if hash gio 2>/dev/null; then
  function open() {
    gio open $1 >/dev/null 2>&1
  }
elif hash xdg-open 2>/dev/null; then
  function open() {
    xdg-open $1 >/dev/null 2>&1
  }
fi

# x-tools
if [ -d ~/x-tools ]; then
  TPATH="$PATH"
  for dir in $(find "$HOME/x-tools" -mindepth 1 -maxdepth 1 -type d -a ! -name '*HOST-*' -printf '%f '); do
    TPATH="$TPATH:$HOME/x-tools/$dir/bin"
  done
  export PATH="$TPATH"
fi

# Modern CLI tools
# eza (modern ls replacement)
if hash eza 2>/dev/null; then
  alias ls='eza --group-directories-first --icons'
  alias l='eza -la --group-directories-first --time-style iso --icons'
  alias ll='eza -l --group-directories-first --time-style iso --icons'
  alias lt='eza --tree --level=2 --icons'
elif hash exa 2>/dev/null; then
  # Fallback to exa if eza not available
  alias ls='exa --group-directories-first'
  alias l='exa -la --group-directories-first --time-style iso'
fi

# bat (better cat)
if hash bat 2>/dev/null; then
  alias cat='bat --paging=never'
  alias catp='bat'  # with paging
  export BAT_THEME="Seoul256"
fi

# fd (better find)
if hash fd 2>/dev/null; then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi

# delta (better git diff)
if hash delta 2>/dev/null; then
  export GIT_PAGER='delta'
fi

# ripgrep config
if hash rg 2>/dev/null; then
  export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"
fi

# zoxide (smart cd)
if hash zoxide 2>/dev/null; then
  eval "$(zoxide init zsh)"
  alias cd='z'
  alias cdi='zi'  # interactive
fi

# wttr.in
wttr() {
  LOCATION=${1// /+}
  curl v2.wttr.in/$LOCATION
}

# neovim, vim
if hash nvim 2>/dev/null; then
  export EDITOR=nvim
  alias vim='nvim'
  alias vi='nvim'
elif hash vim 2>/dev/null; then
  export EDITOR=vim
  alias vi='vim'
fi

# Load local zshrc
if [ -f ~/.zshrc.local ]; then
  source ~/.zshrc.local
fi

# Auto-attach to tmux session
# Only run if:
# 1. tmux is installed
# 2. Not already in tmux
# 3. Not in VS Code terminal
if command -v tmux &> /dev/null && [ -z "$TMUX" ] && [ -z "$VSCODE_TERMINAL" ]; then
  # Get the number of existing sessions
  session_count=$(tmux list-sessions 2>/dev/null | wc -l)

  if [ "$session_count" -eq 0 ]; then
    # No sessions exist, create a new one
    tmux new -s main
  elif [ "$session_count" -eq 1 ]; then
    # Only one session exists, attach to it
    tmux attach
  else
    # Multiple sessions exist, attach to the most recent one
    # (tmux sorts sessions by creation time)
    tmux attach
    # Or if you prefer to choose: comment above and uncomment below
    # echo "Multiple tmux sessions found:"
    # tmux list-sessions
    # echo "Run 'tmux attach -t <session-name>' to connect"
  fi
fi

# API Keys from 1Password (via ~/.config/env-tokens)
# Usage: op-exec your-command
alias opr='op run --env-file ~/.config/env-tokens --'

export GEMINI_API_KEY=$(op item get "gemini api key" --fields credential 2>/dev/null)


# npm registry fix (override company VPN/MDM settings)
export NPM_CONFIG_REGISTRY=https://registry.npmjs.org/

# Daily automation shortcuts (added by Claude Code)
alias dashboard='~/me/scripts/dashboard.py --snapshot'
alias morning='~/me/scripts/daily-morning.sh'
alias evening='~/me/scripts/daily-evening.sh'
alias planner='~/me/scripts/daily-planner.py'
alias stats='~/me/scripts/achievement-stats.py'

# Feature usage tracking (auto-added by Claude Code)
_track_usage() {
    ~/me/scripts/track-feature-usage.sh "$1" 2>/dev/null
}

# Override aliases with tracking
alias dashboard='_track_usage dashboard && ~/me/scripts/dashboard.py --snapshot'
alias planner='_track_usage daily-planner && ~/me/scripts/daily-planner.py'
alias morning='_track_usage daily-morning && ~/me/scripts/daily-morning.sh'
alias evening='_track_usage daily-evening && ~/me/scripts/daily-evening.sh'
alias stats='_track_usage achievement-stats && ~/me/scripts/achievement-stats.py'

# Second Brain Quick Access
alias sb='cd ~/me/second-brain-mvp && source venv/bin/activate && python3 search.py'
alias sbh='cd ~/me/second-brain-mvp && source venv/bin/activate && python3 hybrid_search.py'
alias sbi='cd ~/me/second-brain-mvp && source venv/bin/activate && python3 search.py'  # Interactive mode

# ═══════════════════════════════════════════
# Review Systems v7.1 (2025-10-20)
# ═══════════════════════════════════════════
alias vote="~/me/scripts/review/3.vote/quality-3ai.sh"
alias 2v1="~/me/scripts/review/5.logic/2v1.sh"
alias debate="~/me/scripts/review/2.debate/multi-expert.sh"
alias pr-analyze="~/me/scripts/review/4.analysis/pr-3tier.sh"
alias pr-hist="~/me/scripts/review/context/historical.sh"
alias pr-sem="~/me/scripts/review/context/semantic.sh"
alias pr-impact="~/me/scripts/review/context/impact.sh"

# Quick access to review docs
alias review-guide="cat ~/me/scripts/review/README.md"

# Review Systems v7.1 (2025-10-20)
alias vote="~/me/scripts/review/3.vote/quality-3ai.sh"
alias 2v1="~/me/scripts/review/5.logic/2v1.sh"
alias debate="~/me/scripts/review/2.debate/multi-expert.sh"
alias pr-analyze="~/me/scripts/review/4.analysis/pr-3tier.sh"
alias pr-hist="~/me/scripts/review/context/historical.sh"
alias pr-sem="~/me/scripts/review/context/semantic.sh"
alias pr-impact="~/me/scripts/review/context/impact.sh"
alias review-guide="cat ~/me/scripts/review/README.md"


# Evaluation stats (Session 61)
alias evalstats='cd ~/me && python3 scripts/lib/query_logger.py stats 1'
alias evalstats7='cd ~/me && python3 scripts/lib/query_logger.py stats 7'

# Kidsnote Skill Tracker Aliases
source ~/me/scripts/skill-aliases.sh

# API Keys from 1Password
export ANTHROPIC_API_KEY=$(op item get "anthropic api key" --fields credential 2>/dev/null)
