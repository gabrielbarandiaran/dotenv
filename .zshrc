# ~/.zshrc — minimal zsh setup

# ── Brew shellenv (PATH/MANPATH/etc) ──
eval "$(/opt/homebrew/bin/brew shellenv)"
BREW_PREFIX="$(brew --prefix)"

# ── PATH additions ──
export PATH="$HOME/.config/scripts:$PATH"
export PATH="$HOME/.local/share/nvim/mason/bin:$PATH"

# ── Env ──
export LANG=en_US.UTF-8
export XDG_CONFIG_HOME="$HOME/.config"
export EDITOR=nvim
export VISUAL=nvim
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"

# Go
export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$BREW_PREFIX/opt/nvm/nvm.sh" ] && \. "$BREW_PREFIX/opt/nvm/nvm.sh"

# Android — SDK + AVDs live on the external SSD so the internal disk stays free
export ANDROID_HOME="/Volumes/Barandiaran/Dev/android/sdk"
export ANDROID_SDK_ROOT="$ANDROID_HOME"
export ANDROID_AVD_HOME="/Volumes/Barandiaran/Dev/android/avd"
export PATH="$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator:$PATH"

# ── History ──
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY HIST_IGNORE_DUPS HIST_IGNORE_SPACE

# ── Completion (built-in zsh) ──
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'  # case-insensitive

# ── Aliases ──
alias c="clear"
alias e="exit"
alias v="nvim"
alias ll="ls -la"
alias la="ls -A"
# Git
alias gs="git status -s"
alias ga="git add"
alias gc="git commit -m"
alias gp="git push"
alias gl="git log --oneline --graph --all"
alias gd="git diff"

# ── Plugins ──
[ -f "$BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ] && \
  source "$BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
[ -f "$BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ] && \
  source "$BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# ── Prompt ──
command -v starship >/dev/null && eval "$(starship init zsh)"
