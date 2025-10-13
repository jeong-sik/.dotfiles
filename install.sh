#!/usr/bin/env bash
set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[✓]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Get script directory
BASEDIR="$(cd "$(dirname "$0")" && pwd)"

# Environment selection
ENV_TYPE="${1:-}"
if [[ -z "$ENV_TYPE" ]]; then
    echo "Select environment type:"
    echo "1) work"
    echo "2) personal"
    read -p "Enter choice [1-2]: " choice
    case $choice in
        1) ENV_TYPE="work" ;;
        2) ENV_TYPE="personal" ;;
        *) log_error "Invalid choice"; exit 1 ;;
    esac
fi

log_info "Setting up dotfiles for '$ENV_TYPE' environment"

# Check locale
locale -k LC_CTYPE | grep -qi 'charmap="utf-\+8"' || {
    log_warn "Locale should be UTF-8"
}

# Check OS
OS="$(uname -s)"
if [[ "$OS" != "Darwin" && "$OS" != "Linux" ]]; then
    log_error "Unsupported OS: $OS"
    exit 1
fi

# Install Homebrew (macOS only)
if [[ "$OS" == "Darwin" ]]; then
    if ! command -v brew >/dev/null 2>&1; then
        log_info "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        # Add Homebrew to PATH
        if [[ -f /opt/homebrew/bin/brew ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        elif [[ -f /usr/local/bin/brew ]]; then
            eval "$(/usr/local/bin/brew shellenv)"
        fi
    fi

    # Install packages from Brewfile
    if [[ -f "$BASEDIR/manual/homebrew/Brewfile" ]]; then
        log_info "Installing Homebrew packages..."
        brew bundle --file="$BASEDIR/manual/homebrew/Brewfile" || log_warn "Some packages failed to install"
    fi
fi

# Check dependencies
DEPS="git curl zsh"
for dep in $DEPS; do
    if ! command -v $dep >/dev/null 2>&1; then
        log_error "Please install $dep"
        exit 1
    fi
    log_success "$dep is installed"
done

# Install zinit (updated path)
if [[ ! -d "$HOME/.local/share/zinit/zinit.git" ]]; then
    log_info "Installing zinit..."
    ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
    log_success "zinit installed"
else
    log_info "zinit already installed"
fi

# Install vim-plug for both Vim and Neovim
log_info "Installing vim-plug..."
# For Vim
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
# For Neovim
if command -v nvim >/dev/null 2>&1; then
    curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi
log_success "vim-plug installed"

# Install fzf
if [[ ! -d "$HOME/.fzf" ]]; then
    log_info "Installing fzf..."
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --all --no-bash --no-fish
    log_success "fzf installed"
else
    log_info "fzf already installed"
fi

# Install nvm if not already installed
if [[ ! -d "$HOME/.nvm" ]]; then
    log_info "Installing nvm..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/latest/install.sh | bash
    log_success "nvm installed"
else
    log_info "nvm already installed"
fi

# Install pyenv (macOS)
if [[ "$OS" == "Darwin" ]] && ! command -v pyenv >/dev/null 2>&1; then
    log_info "Installing pyenv..."
    brew install pyenv pyenv-virtualenv
    log_success "pyenv installed"
fi

# Create symlinks
log_info "Creating symlinks..."

# Core dotfiles
CORE_DOTFILES=".zshrc .vimrc .tmux.conf .gitconfig .p10k.zsh"
for dotfile in $CORE_DOTFILES; do
    source_file="$BASEDIR/core/$dotfile"
    target_file="$HOME/$dotfile"

    if [[ -f "$source_file" ]]; then
        # Backup existing files
        if [[ -e "$target_file" && ! -L "$target_file" ]]; then
            log_warn "Backing up existing $dotfile to ${dotfile}.backup"
            mv "$target_file" "${target_file}.backup"
        fi

        ln -sf "$source_file" "$target_file"
        log_success "Linked $dotfile"
    else
        log_warn "$dotfile not found in core/"
    fi
done

# Additional configs
ln -sf "$BASEDIR/.npmrc" "$HOME/.npmrc"
ln -sf "$BASEDIR/.gitignore-global" "$HOME/.gitignore-global"
ln -sf "$BASEDIR/.ideavimrc" "$HOME/.ideavimrc"

# Neovim config
log_info "Setting up Neovim config..."
mkdir -p ~/.config/nvim
ln -sf "$BASEDIR/core/.vimrc" ~/.config/nvim/init.vim
ln -sf "$BASEDIR/coc-settings.json" ~/.config/nvim/coc-settings.json
log_success "Neovim config linked"

# Create .zshrc.local with environment selection
log_info "Creating .zshrc.local..."
cat > "$HOME/.zshrc.local" << EOF
# Dotfiles environment configuration
export DOTFILES_ENV="$ENV_TYPE"
export DOTFILES_DIR="$BASEDIR"

# Load environment-specific configuration
if [[ -f "\$DOTFILES_DIR/env/\$DOTFILES_ENV.zsh" ]]; then
    source "\$DOTFILES_DIR/env/\$DOTFILES_ENV.zsh"
fi

# User-specific local settings can go here
EOF
log_success ".zshrc.local created with $ENV_TYPE environment"

# Install Vim/Neovim plugins
log_info "Installing Vim plugins..."
vim +PlugInstall +qall 2>/dev/null || log_warn "Vim plugin installation failed"

if command -v nvim >/dev/null 2>&1; then
    log_info "Installing Neovim plugins..."
    nvim +PlugInstall +qall 2>/dev/null || log_warn "Neovim plugin installation failed"
fi

# Install CoC.nvim extensions
if command -v nvim >/dev/null 2>&1; then
    log_info "Installing CoC.nvim extensions..."
    nvim -c 'CocInstall -sync coc-tsserver coc-json coc-highlight coc-rust-analyzer' -c 'qall' 2>/dev/null || log_warn "CoC extensions installation failed"
fi

# Final instructions
echo ""
log_success "Dotfiles installation complete!"
echo ""
echo "Next steps:"
echo "1. Restart your terminal or run: source ~/.zshrc"
echo "2. If using tmux, reload config: tmux source-file ~/.tmux.conf"
echo "3. For Homebrew packages, run: brew bundle --file=$BASEDIR/manual/homebrew/Brewfile"
echo ""
echo "Environment: $ENV_TYPE"
echo "To switch environments, edit ~/.zshrc.local and change DOTFILES_ENV"