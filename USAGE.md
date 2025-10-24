# Dotfiles 사용 가이드

이 dotfiles를 사용하기 전에 필요한 도구와 선택적 기능을 확인하세요.

---

## 📋 필수 도구 (Required)

이 dotfiles는 다음 도구들을 **반드시** 설치해야 합니다:

### 1. Homebrew
```bash
# macOS
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### 2. Zsh (macOS 기본 포함)
```bash
# 확인
zsh --version

# 없으면 설치
brew install zsh
```

### 3. Git
```bash
# macOS 기본 포함, 또는
brew install git
```

---

## 🦀 Modern CLI Tools (강력 권장)

이 dotfiles는 전통적인 Unix 도구를 현대적인 Rust 기반 대체품으로 교체합니다:

### 설치 (한 번에)
```bash
brew install ripgrep bat eza fd fzf
```

### 개별 설치
```bash
# ripgrep (grep 대체, 53x faster)
brew install ripgrep

# bat (cat 대체, syntax highlighting)
brew install bat

# eza (ls 대체, git-aware)
brew install eza

# fd (find 대체, 68x faster)
brew install fd

# fzf (fuzzy finder)
brew install fzf
```

### 사용하지 않으려면?

**Option 1: 도구만 제거 (alias 유지)**
- 설치 안 하면 자동으로 원본 명령어 사용
- 에러 없음, 원본 `grep`, `cat`, `ls` 작동

**Option 2: Alias 완전 제거**
```bash
# ~/.zshrc에서 107-128 라인 삭제 또는 주석 처리
# core/.zshrc 파일 107-128 라인:

# Modern CLI tools (Rust-based, faster alternatives)
# alias grep='rg'
# alias cat='bat --paging=never --style=plain'
# alias ls='eza'
# ... (이 섹션 전체 주석 처리)
```

---

## 🎨 Terminal Enhancements (선택)

### Powerlevel10k Theme
```bash
# zinit으로 자동 설치됨 (zinit 필요)
# 수동 설치:
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
```

**사용 안 하려면**: `core/.zshrc` 35-36 라인 삭제
```bash
# zinit ice depth=1
# zinit light romkatv/powerlevel10k
```

### Zinit Plugin Manager
```bash
# XDG 표준 경로에 설치
bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"
```

**사용 안 하려면**: `core/.zshrc` 26-50 라인 삭제 (zinit 전체 섹션)

---

## 🚀 Claude Code Integration (선택)

Claude parallel session 기능 (`cps`, `cps4`)

### 필수 도구
```bash
# 1. tmux (세션 관리)
brew install tmux

# 2. Claude Code CLI
npm install -g @anthropic-ai/claude-code

# 3. Git worktree 스크립트
# ~/me/scripts/parallel-session.sh 필요
```

### 사용 안 하려면?

**core/.zshrc 130-198 라인 삭제**:
```bash
# Claude Parallel Session (tmux + Alacritty)
cps() {
  ...
}

cps4() {
  ...
}
```

---

## 🔐 1Password CLI (선택)

API 키 관리용

### 설치
```bash
brew install 1password-cli
```

### 설정
```bash
# 1Password 앱에 API 키 저장 후
op item get "your-item-name" --fields credential
```

### 사용 안 하려면?

**Option 1: 환경변수로 직접 관리**
```bash
# core/.zshrc 411, 474 라인 수정
export GEMINI_API_KEY="your-key-here"
export ANTHROPIC_API_KEY="your-key-here"
```

⚠️ **위험**: Git에 커밋하지 마세요!

**Option 2: 완전 제거**
```bash
# core/.zshrc 411, 474 라인 삭제
# export GEMINI_API_KEY=$(op item get ...)
# export ANTHROPIC_API_KEY=$(op item get ...)
```

---

## 📊 Review Systems (선택)

코드 리뷰 자동화 스크립트 (프로젝트별)

### 필요 조건
- Python 3.8+
- `~/me/scripts/review/` 디렉토리
- Anthropic API 키

### 사용 안 하려면?

**core/.zshrc에서 삭제**:
```bash
# 352-365 라인, 387-400 라인
alias vote="~/me/scripts/review/3.vote/quality-3ai.sh"
alias 2v1="~/me/scripts/review/5.logic/2v1.sh"
# ... (review 관련 alias 전부)
```

---

## 💻 개발 도구 (선택)

### Neovim
```bash
brew install neovim

# Lazy.nvim (플러그인 매니저) 자동 설치됨
```

**설정 파일**: `config/nvim/init.lua`

### Tmux
```bash
brew install tmux

# TPM (Tmux Plugin Manager)
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

**설정 파일**: `core/.tmux.conf`

---

## 🗑️ 프로젝트별 설정 제거 가이드

일부 설정은 특정 프로젝트(`~/me`)에 종속되어 있습니다.

### 제거할 항목

#### 1. Second Brain Aliases (290-292 라인)
```bash
alias sb='cd ~/me/second-brain-mvp && ...'
alias sbh='cd ~/me/second-brain-mvp && ...'
alias sbi='cd ~/me/second-brain-mvp && ...'
```

#### 2. Dashboard/Planner (281-288 라인)
```bash
alias dashboard='...'
alias planner='...'
alias morning='...'
alias evening='...'
```

#### 3. Review Systems (352-400 라인)
```bash
alias vote="~/me/scripts/..."
alias debate="~/me/scripts/..."
# ... 전부
```

#### 4. Kidsnote Skill Tracker (470 라인)
```bash
source ~/me/scripts/skill-aliases.sh
```

---

## ✅ 최소 설치 (Minimal Setup)

**필수만 사용하려면**:

1. **설치**:
   ```bash
   brew install git zsh
   ```

2. **제거할 섹션** (core/.zshrc):
   - 107-128: Modern CLI tools
   - 130-198: Claude parallel sessions
   - 200-235: fzf
   - 280-292: Second Brain
   - 352-400: Review systems
   - 411, 474: 1Password

3. **결과**:
   - 기본 Zsh 설정만 사용
   - 외부 도구 의존성 없음
   - 가볍고 빠른 시작

---

## 🔍 라인 번호 찾기

```bash
# 특정 기능 찾기
grep -n "Claude Parallel" ~/.zshrc
grep -n "Modern CLI" ~/.zshrc
grep -n "1Password" ~/.zshrc

# 또는 에디터에서
vim +108 ~/.zshrc  # 108번 라인으로 점프
```

---

## 🚀 추천 설정

**일반 사용자**:
```bash
brew install ripgrep bat eza fd fzf
# Modern CLI tools만 설치
# 나머지는 제거
```

**개발자**:
```bash
brew install ripgrep bat eza fd fzf tmux neovim
# + Claude Code (선택)
# + 1Password CLI (API 키 관리)
```

**풀 스택**:
```bash
# 모든 도구 설치
# Review systems 포함
# 프로젝트별 스크립트 유지
```

---

## 🆘 문제 해결

### 명령어가 안 먹혀요
```bash
# 원인: 도구 미설치
which rg bat eza fd

# 해결: 설치 또는 alias 제거
brew install ripgrep bat eza fd
# 또는 core/.zshrc에서 alias 주석 처리
```

### 에러 메시지가 떠요
```bash
# 예: "command not found: op"
# 원인: 1Password CLI 없음
# 해결: 설치 또는 해당 라인 제거

# core/.zshrc 411, 474 라인 삭제
```

### 느려요
```bash
# 원인: 많은 플러그인/스크립트
# 해결: 안 쓰는 기능 제거 (위 가이드 참고)

# 특히 효과 큰 것:
# - Review systems (많은 Python 스크립트)
# - Second Brain (DB 쿼리)
```

---

## 📚 더 알아보기

- [README.md](README.md) - 전체 기능 소개
- [core/.zshrc](core/.zshrc) - 설정 파일 원본
- [config/nvim/](config/nvim/) - Neovim 설정
- [manual/homebrew/Brewfile](manual/homebrew/Brewfile) - Homebrew 패키지 목록

---

**질문이나 제안**: [GitHub Issues](https://github.com/jeong-sik/.dotfiles/issues)
