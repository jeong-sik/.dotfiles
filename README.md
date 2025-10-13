# Modern Dotfiles 🚀

[![License](https://img.shields.io/badge/license-Apache%202.0%2FMIT-blue.svg)](COPYRIGHT)

A modern, organized dotfiles setup with environment separation (work/personal) and automatic installation.

## Features

- 🎯 **Environment Separation**: Separate configs for work and personal use
- 🛠️ **Modern CLI Tools**: Replaces traditional tools with modern alternatives
- 📦 **Automatic Installation**: Smart install script with dependency management
- 🎨 **Beautiful Terminal**: Powerlevel10k + modern syntax highlighting
- 💻 **Cross-platform**: Works on macOS and Linux

## Directory Structure

```
.dotfiles/
├── core/              # Core configuration files
│   ├── .zshrc         # Zsh configuration
│   ├── .vimrc         # Vim/Neovim configuration
│   ├── .tmux.conf     # Tmux configuration
│   ├── .gitconfig     # Git configuration
│   └── .p10k.zsh      # Powerlevel10k theme
├── env/               # Environment-specific configs
│   ├── work.zsh       # Work environment settings
│   └── personal.zsh   # Personal environment settings
├── config/            # Application configs
│   └── nvim/          # Neovim specific configs
├── manual/            # Manual installation resources
│   └── homebrew/
│       └── Brewfile   # Homebrew packages list
└── install.sh         # Installation script
```

## Quick Install

### Option 1: Interactive Install
```bash
git clone https://github.com/tirr-c/.dotfiles ~/.dotfiles
cd ~/.dotfiles
./install.sh
# Select environment: 1) work or 2) personal
```

### Option 2: Direct Environment Install
```bash
git clone https://github.com/tirr-c/.dotfiles ~/.dotfiles
cd ~/.dotfiles
./install.sh work    # For work environment
# or
./install.sh personal # For personal environment
```

## Modern CLI Tools Included

| Traditional | Modern Replacement | Description |
|------------|-------------------|-------------|
| `ls` | `eza` | Modern ls with icons and git integration |
| `cat` | `bat` | Syntax highlighting and line numbers |
| `find` | `fd` | Simpler and faster alternative |
| `grep` | `ripgrep` | Much faster grep |
| `top` | `bottom` | Better resource monitor |
| `du` | `dust` | More intuitive disk usage |
| `cd` | `zoxide` | Smarter directory jumping |

## Key Bindings

### Vim
- `<leader><tab>` - Fuzzy file finder
- `<leader>q` - Buffer list
- `gd` - Go to definition (CoC)
- `<leader>rn` - Rename symbol (CoC)
- `<tab><tab>` - Switch to previous buffer
- `<tab>h/j/k/l` - Navigate windows

### Tmux
- `Ctrl-a` - Prefix (if configured)
- `Prefix + |` - Vertical split
- `Prefix + -` - Horizontal split

## Environment Switching

After installation, your environment is set in `~/.zshrc.local`. To switch:

```bash
# Edit ~/.zshrc.local
export DOTFILES_ENV="work"    # or "personal"
```

## Manual Steps

### Install Homebrew Packages (macOS)
```bash
brew bundle --file=~/.dotfiles/manual/homebrew/Brewfile
```

### Install Neovim Plugins
```bash
nvim +PlugInstall +qall
nvim +CocInstall coc-tsserver coc-json +qall
```

## Customization

### Local Overrides
- `~/.zshrc.local` - Local zsh configurations
- `~/.vimrc.local` - Local vim configurations
- `~/.work-secrets` - Work-specific secrets (gitignored)

### Adding New Environments
1. Create new file in `env/` directory (e.g., `env/gaming.zsh`)
2. Set `DOTFILES_ENV="gaming"` in `~/.zshrc.local`
3. Restart terminal

## Updates

To update your dotfiles:
```bash
cd ~/.dotfiles
git pull
./install.sh $DOTFILES_ENV  # Re-run with your environment
```

## Troubleshooting

### Zinit Not Loading
- Make sure `~/.local/share/zinit/zinit.git` exists
- Try: `git clone https://github.com/zdharma-continuum/zinit.git ~/.local/share/zinit/zinit.git`

### CoC.nvim Extensions Not Working
- Run `:CocInstall` for each extension inside Neovim
- Check Node.js is installed: `node --version`

### Fonts Not Rendering
- Install Nerd Fonts: `brew install --cask font-meslo-lg-nerd-font`
- Configure your terminal to use "MesloLGS NF"

## What's Been Fixed

### Recent Improvements (2024)
- ✅ Fixed install.sh condition bug
- ✅ Updated deprecated packages (zinit, fast-syntax-highlighting)
- ✅ Replaced `exa` with `eza`
- ✅ Removed duplicate vim settings
- ✅ Fixed CoC extension installation
- ✅ Added environment separation (work/personal)
- ✅ Cleaned up 100+ lines of unnecessary colormap code
- ✅ Added modern CLI tool configurations

## Credits

Original `.zshrc`, `.vimrc`, and `.tmux.conf` derived from [simnalamburt/.dotfiles](https://github.com/simnalamburt/.dotfiles).

## License

Apache-2.0/MIT. See [COPYRIGHT](COPYRIGHT) for details.