#!/usr/bin/env zsh
# Personal environment specific settings

# Personal projects
export PERSONAL_ENV=true

# Git config for personal projects
export GIT_AUTHOR_EMAIL="jeong-sik@personal.com"
export GIT_COMMITTER_EMAIL="jeong-sik@personal.com"

# Personal aliases
alias blog='cd ~/personal/blog'
alias side='cd ~/personal/side-projects'

# GitHub CLI
export GH_TOKEN_PERSONAL="$(<~/.gh-personal-token 2>/dev/null)"

# Personal cloud services
alias dropbox='cd ~/Dropbox'
alias icloud='cd ~/Library/Mobile\ Documents/com~apple~CloudDocs'

# Development preferences
export EDITOR="nvim"
export BROWSER="open -a 'Google Chrome'"

# Personal project paths
export PERSONAL_DIR="$HOME/personal"
export SANDBOX_DIR="$PERSONAL_DIR/sandbox"

echo "🏠 Personal environment loaded"