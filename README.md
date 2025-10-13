# Modern Dotfiles 🚀

[![License](https://img.shields.io/badge/license-Apache%202.0%2FMIT-blue.svg)](COPYRIGHT)

A modern, organized dotfiles setup with environment separation (work/personal) and automatic installation.

## Features

- 🎯 **Environment Separation**: Separate configs for work and personal use
- 🛠️ **Modern CLI Tools**: Replaces traditional tools with modern alternatives
- 📦 **Automatic Installation**: Smart install script with dependency management
- 🎨 **Beautiful Terminal**: Powerlevel10k + modern syntax highlighting
- 💻 **Cross-platform**: Works on macOS and Linux
- 🚀 **Full Dev Stack**: Nvim (LSP, Git, Terminal) + Tmux (Session Mgmt) + Alacritty
- 💾 **Auto Session Restore**: Never lose your work (tmux-resurrect + continuum)
- 🎯 **Productivity Plugins**: File bookmarks, TODO tracking, project detection

## Directory Structure

```
.dotfiles/
├── core/              # Core configuration files
│   ├── .zshrc         # Zsh configuration
│   ├── .vimrc         # Vim configuration (legacy)
│   ├── .tmux.conf     # Tmux configuration
│   ├── .gitconfig     # Git configuration
│   └── .p10k.zsh      # Powerlevel10k theme
├── config/            # Modern application configs
│   ├── nvim/          # Neovim Lua config (modern)
│   │   ├── init.lua   # Main Neovim config with Lazy.nvim
│   │   └── lazy-lock.json  # Plugin version lock
│   └── alacritty/     # Alacritty terminal config
│       └── alacritty.toml
├── env/               # Environment-specific configs
│   ├── work.zsh       # Work environment settings
│   └── personal.zsh   # Personal environment settings
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

## Quick Start Guide

### The 3-Tool Combo: Alacritty + Tmux + Nvim

```
┌─────────────────────────────────────────────────┐
│ Alacritty (터미널)                               │
│  └── Tmux (세션/윈도우/패널 관리)                  │
│       └── Nvim (코드 편집)                        │
└─────────────────────────────────────────────────┘
```

**핵심 워크플로우**:
1. **Alacritty** 열기 → Tmux 자동 시작
2. **Tmux** 안에서 패널/윈도우 생성 → 다중 작업
3. **Nvim** 열기 → 코드 편집, git 관리, 터미널 토글
4. 재부팅해도 **Tmux가 모든 세션 복원** ✅

### Most Used Keys (외우면 끝)

#### 전체에서 가장 많이 쓰는 것
```bash
Ctrl+q          # Tmux prefix (모든 tmux 명령의 시작)
<Space>         # Nvim leader (모든 nvim 명령의 시작)
Option+k/j      # Tmux 스크롤 (어디서나)
Ctrl+\          # Nvim 터미널 토글
<Space>gg       # LazyGit 열기 (git UI)
ESC             # 영문 전환 (즉시)
```

#### 파일 작업
```bash
Ctrl+p          # 파일 찾기 (Telescope)
<Space>a        # 파일 북마크 (Harpoon)
Ctrl+e          # 북마크 메뉴
<Space>1-4      # 북마크 1-4 이동
```

#### Git 작업
```bash
<Space>gg       # LazyGit (전체)
]c / [c         # 다음/이전 변경사항
<Space>hp       # 변경사항 미리보기
```

#### Tmux 필수
```bash
Ctrl+q |        # 세로 분할
Ctrl+q -        # 가로 분할
Ctrl+q h/j/k/l  # 패널 이동
Ctrl+q c        # 새 윈도우
```

---

## Key Bindings

### Neovim (Modern Config with Lazy.nvim)

**Leader Key**: `<Space>`

#### Git Operations (LazyGit + Gitsigns)
| Key | Description |
|-----|-------------|
| `<Space>gg` | Open LazyGit (full git UI) |
| `<Space>gl` | LazyGit for current file |
| `<Space>gc` | LazyGit commits for current file |
| `]c` / `[c` | Next/Previous git hunk |
| `<leader>hp` | Preview hunk |
| `<leader>hs` | Stage hunk |
| `<leader>hr` | Reset hunk |
| `<leader>hb` | Show git blame for line |
| `<leader>tb` | Toggle git blame display |

**LazyGit Controls** (inside LazyGit):
- `Tab`/`Shift+Tab` - Navigate panels
- `1-5` - Jump to panel (Status/Files/Branches/Commits/Stash)
- `Space` - Stage/unstage
- `c` - Commit
- `p`/`P` - Push/Pull
- `l` - View log
- `d` - View diff
- `q` - Quit

#### File Navigation (Telescope)
| Key | Description |
|-----|-------------|
| `Ctrl+p` | Quick file finder (CtrlP style) |
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep (search in files) |
| `<leader>fb` | Browse buffers |
| `<leader>fs` | Git status |
| `<leader>fd` | Show diagnostics |
| `<leader>ft` | Find TODOs |
| `<leader>e` | Toggle NvimTree |

#### Terminal
| Key | Description |
|-----|-------------|
| `Ctrl+\` | Toggle floating terminal |

#### File Bookmarks (Harpoon)
| Key | Description |
|-----|-------------|
| `<leader>a` | Add current file to bookmarks |
| `Ctrl+e` | Toggle bookmark menu |
| `<leader>1` | Jump to bookmark 1 |
| `<leader>2` | Jump to bookmark 2 |
| `<leader>3` | Jump to bookmark 3 |
| `<leader>4` | Jump to bookmark 4 |

#### TODO Navigation
| Key | Description |
|-----|-------------|
| `]t` | Next TODO comment |
| `[t` | Previous TODO comment |
| `<leader>ft` | Search all TODOs (Telescope) |

#### Markdown
| Key | Description |
|-----|-------------|
| `<leader>mp` | Open markdown preview |
| `<leader>ms` | Stop markdown preview |

#### LSP & Code Navigation
| Key | Description |
|-----|-------------|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gi` | Go to implementation |
| `gr` | Show references |
| `K` | Show hover documentation |
| `<leader>vrn` | Rename symbol |
| `<leader>vca` | Code actions |
| `<leader>f` | Format code |
| `[d`/`]d` | Next/Previous diagnostic |

#### Window & Editing
| Key | Description |
|-----|-------------|
| `Ctrl+h/j/k/l` | Navigate windows (vim style) |
| `J`/`K` (visual) | Move selected lines up/down |
| `<`/`>` (visual) | Decrease/increase indent (persistent) |

#### IME (한영 전환)
| Key | Description |
|-----|-------------|
| `ESC` | Switch to English (instant) |
| `Ctrl+c` | Switch to English (instant) |

### Tmux

**Prefix Key**: `Ctrl+q` (changed from default `Ctrl+b`)

#### Scrolling (Keyboard & Mouse)
| Key | Description |
|-----|-------------|
| `Option+k` or `Option+↑` | Scroll up (line) |
| `Option+j` or `Option+↓` | Scroll down (line) |
| `Option+u` | Scroll up (half page) |
| `Option+d` | Scroll down (half page) |
| `PageUp` | Enter copy mode & scroll up |
| **Mouse wheel** | Scroll (automatic) |

#### Pane Management
| Key | Description |
|-----|-------------|
| `Prefix \|` | Split vertically (current path) |
| `Prefix -` | Split horizontally (current path) |
| `Prefix h/j/k/l` | Navigate panes (vim style) |
| `Prefix H/J/K/L` | Resize panes (repeatable) |
| `Prefix Tab` | Cycle through panes |
| `Prefix X` | Kill pane (no confirmation) |
| `Prefix B` | Break pane to new window |

#### Window Management
| Key | Description |
|-----|-------------|
| `Prefix c` | New window (current path) |
| `Prefix Ctrl+h/l` | Previous/Next window |
| `Prefix </>` | Swap window left/right |

#### Copy Mode (Vi-style)
| Key | Description |
|-----|-------------|
| `Prefix [` | Enter copy mode |
| `v` | Begin selection (copy mode) |
| `y` | Copy and exit (copy mode) |
| `Prefix p` | Paste |

#### Session Management (TPM + Resurrect + Continuum)
| Key | Description |
|-----|-------------|
| `Prefix Ctrl+s` | Save session manually |
| `Prefix Ctrl+r` | Restore session manually |
| **Auto-save** | Every 15 minutes (automatic) |
| **Auto-restore** | On tmux start (automatic) |

#### Misc
| Key | Description |
|-----|-------------|
| `Prefix r` | Reload tmux config |
| `Prefix Ctrl+k` | Clear screen + history |
| `Prefix I` | Install plugins (after config change) |
| `Prefix U` | Update plugins |

### Alacritty

#### Terminal Features
| Key | Description |
|-----|-------------|
| `Ctrl+Shift+C` | Copy |
| `Ctrl+Shift+V` | Paste |
| `Shift+Ctrl+Space` | Toggle Vi mode |

#### Scrolling (macOS, outside tmux)
| Key | Description |
|-----|-------------|
| `Cmd+Shift+K/J` | Scroll line up/down |
| `Cmd+Shift+U/D` | Scroll half page up/down |
| `Cmd+Shift+B/F` | Scroll full page up/down |

**Note**: Inside tmux, use tmux scroll keys (`Option+k/j`)

#### Tmux Integration (macOS)
| Key | Description |
|-----|-------------|
| `Cmd+T` | New tmux window |
| `Cmd+W` | Close tmux window |
| `Cmd+D` | Vertical split |
| `Cmd+Shift+D` | Horizontal split |
| `Cmd+1-9` | Jump to window 1-9 |
| `Cmd+O` | Next pane |
| `Cmd+←/↓/↑/→` | Navigate panes |

## Installed Plugins & Tools

### Neovim Plugins (via Lazy.nvim)
- **Git**: LazyGit (TUI), Gitsigns (inline blame & hunks)
- **LSP**: Mason (LSP installer), nvim-lspconfig, nvim-cmp (completion)
- **Search**: Telescope (fuzzy finder), Treesitter (syntax)
- **Productivity**:
  - Harpoon (file bookmarks)
  - toggleterm (floating terminal)
  - project.nvim (auto-detect project root)
  - todo-comments (TODO/FIXME highlight & search)
- **Editing**: autopairs, Comment.nvim, which-key
- **UI**: tokyonight (theme), lualine (statusline), nvim-tree (file explorer)
- **Extras**: nvim-colorizer (color preview), markdown-preview

### Tmux Plugins (via TPM)
- **tmux-resurrect**: Manual session save/restore (Prefix + Ctrl+s/r)
- **tmux-continuum**: Auto-save every 15min + auto-restore on start

### CLI Tools (via Homebrew)
- **Modern replacements**: eza, bat, fd, ripgrep, delta, dust, bottom
- **Dev tools**: neovim, tmux, lazygit, gitmux, gh, jq, yq
- **macOS**: macism (IME switcher), alacritty

## Configuration Files

```
~/.config/nvim/init.lua           # Neovim config (modern Lua)
~/.config/alacritty/alacritty.toml # Alacritty terminal
~/.tmux.conf -> ~/.dotfiles/core/.tmux.conf  # Tmux config
~/.zshrc -> ~/.dotfiles/core/.zshrc          # Zsh shell
```

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

### Recent Improvements (2025-10-13)
- ✅ **Migrated to modern Neovim Lua config** with Lazy.nvim
- ✅ **Added LazyGit integration** for full git UI in nvim
- ✅ **Enhanced Gitsigns** with blame, hunk navigation, and keymaps
- ✅ **Added LSP support** with Mason, nvim-cmp, Telescope
- ✅ **IME auto-switch** (ESC → instant English on macOS)
- ✅ **Tmux keyboard scroll** with Option+k/j/u/d
- ✅ **Alacritty config** with tmux integration and Option-as-Alt
- ✅ **Complete keybindings documentation** in README
- ✅ **install.sh updated** to handle modern configs

### Previous Improvements (2024)
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