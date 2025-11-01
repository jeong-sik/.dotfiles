#!/usr/bin/env bash
#
# sync-dotfiles.sh - 현재 환경을 dotfiles로 자동 동기화
#
# Usage:
#   ./sync-dotfiles.sh           # 빠른 동기화 (주요 설정만)
#   ./sync-dotfiles.sh --full    # 전체 동기화 (Brewfile 포함)
#   ./sync-dotfiles.sh --dry-run # 변경사항만 확인

set -euo pipefail

DOTFILES_DIR="$HOME/me/projects/.dotfiles"
DRY_RUN=false
FULL_SYNC=false

# Parse arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --dry-run)
      DRY_RUN=true
      shift
      ;;
    --full)
      FULL_SYNC=true
      shift
      ;;
    *)
      echo "Unknown option: $1"
      echo "Usage: $0 [--dry-run] [--full]"
      exit 1
      ;;
  esac
done

echo "🔄 Dotfiles Sync Starting..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Helper functions
copy_file() {
  local src="$1"
  local dest="$2"

  if [[ ! -f "$src" ]]; then
    echo "⚠️  Skip: $src (not found)"
    return
  fi

  if [[ "$DRY_RUN" == true ]]; then
    if ! diff -q "$src" "$dest" &>/dev/null; then
      echo "📝 Would update: $dest"
    fi
  else
    if ! diff -q "$src" "$dest" &>/dev/null; then
      cp "$src" "$dest"
      echo "✅ Updated: $dest"
    else
      echo "⏭️  Skip: $dest (no changes)"
    fi
  fi
}

copy_dir() {
  local src="$1"
  local dest="$2"

  if [[ ! -d "$src" ]]; then
    echo "⚠️  Skip: $src (not found)"
    return
  fi

  if [[ "$DRY_RUN" == true ]]; then
    echo "📁 Would sync: $src → $dest"
  else
    mkdir -p "$dest"
    # Remove backup files before copying
    find "$src" -type f \( -name "*.backup" -o -name ".DS_Store" \) -delete 2>/dev/null || true
    rsync -a --delete "$src/" "$dest/"
    echo "✅ Synced: $dest"
  fi
}

# 1. Core configs
echo ""
echo "📦 Core Configs"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
copy_file "$HOME/.zshrc" "$DOTFILES_DIR/core/.zshrc"
copy_file "$HOME/.gitconfig" "$DOTFILES_DIR/core/.gitconfig"
copy_file "$HOME/.tmux.conf" "$DOTFILES_DIR/core/.tmux.conf"

# 2. Application configs
echo ""
echo "🎨 Application Configs"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# nvim (lazy-lock.json만 업데이트, init.lua는 symlink라 자동 동기화)
if [[ -f "$HOME/.config/nvim/lazy-lock.json" ]]; then
  copy_file "$HOME/.config/nvim/lazy-lock.json" "$DOTFILES_DIR/config/nvim/lazy-lock.json"
fi

# alacritty (symlink라 skip, 하지만 혹시 모르니 체크)
if [[ -f "$HOME/.config/alacritty/alacritty.toml" ]] && [[ ! -L "$HOME/.config/alacritty/alacritty.toml" ]]; then
  copy_file "$HOME/.config/alacritty/alacritty.toml" "$DOTFILES_DIR/config/alacritty/alacritty.toml"
fi

# hammerspoon
if [[ -f "$HOME/.hammerspoon/init.lua" ]]; then
  copy_file "$HOME/.hammerspoon/init.lua" "$DOTFILES_DIR/config/hammerspoon/init.lua"
fi

# karabiner
if [[ -f "$HOME/.config/karabiner/karabiner.json" ]]; then
  copy_file "$HOME/.config/karabiner/karabiner.json" "$DOTFILES_DIR/config/karabiner/karabiner.json"
fi

# docker
if [[ -f "$HOME/.docker/daemon.json" ]]; then
  copy_file "$HOME/.docker/daemon.json" "$DOTFILES_DIR/config/docker/daemon.json"
fi

# ssh
if [[ -f "$HOME/.ssh/config" ]]; then
  copy_file "$HOME/.ssh/config" "$DOTFILES_DIR/config/ssh/config"
fi

# 3. Brewfile (--full 옵션)
if [[ "$FULL_SYNC" == true ]]; then
  echo ""
  echo "📦 Homebrew Packages"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

  if [[ "$DRY_RUN" == true ]]; then
    echo "📝 Would update: Brewfile"
  else
    echo "⏳ Generating Brewfile..."
    brew bundle dump --file="$DOTFILES_DIR/Brewfile" --force
    echo "✅ Updated: Brewfile"
  fi
fi

# 4. Git status
echo ""
echo "📊 Git Status"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
cd "$DOTFILES_DIR"

if [[ "$DRY_RUN" == true ]]; then
  echo "🔍 Dry-run mode - no changes committed"
  git status --short
else
  if [[ -n $(git status --porcelain) ]]; then
    echo "📝 Changes detected:"
    git status --short
    echo ""
    read -p "💾 Commit changes? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      git add -A
      echo ""
      echo "📝 Enter commit message (or press Enter for default):"
      read -r COMMIT_MSG

      if [[ -z "$COMMIT_MSG" ]]; then
        COMMIT_MSG="chore: dotfiles 자동 동기화 ($(date +%Y-%m-%d))"
      fi

      git commit -m "$COMMIT_MSG

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>"

      echo ""
      read -p "🚀 Push to remote? (y/N): " -n 1 -r
      echo
      if [[ $REPLY =~ ^[Yy]$ ]]; then
        git push origin master
        echo "✅ Pushed to GitHub!"
      fi
    fi
  else
    echo "✅ No changes to commit"
  fi
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✨ Sync Complete!"
echo ""
echo "💡 Next steps:"
echo "   - Review changes: cd $DOTFILES_DIR && git diff"
echo "   - Manual commit: cd $DOTFILES_DIR && git add -A && git commit"
echo "   - Full sync: $0 --full"
