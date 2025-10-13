#!/usr/bin/env zsh
# Work environment specific settings

# Company tools
export COMPANY_ENV=true

# Git config for work
export GIT_AUTHOR_EMAIL="vincent.dev@company.com"
export GIT_COMMITTER_EMAIL="vincent.dev@company.com"

# Work-specific aliases
alias vpn='open -a "Company VPN"'
alias jira='open https://company.atlassian.net'

# Node.js settings for work projects
export NPM_CONFIG_REGISTRY="https://npm.company.com"

# AWS profiles
export AWS_PROFILE="work-dev"

# Docker settings
export DOCKER_DEFAULT_PLATFORM=linux/amd64

# Work project paths
export WORK_DIR="$HOME/work"
export PROJECTS_DIR="$WORK_DIR/projects"

# Load work-specific secrets if exists
[ -f ~/.work-secrets ] && source ~/.work-secrets

echo "📢 Work environment loaded"