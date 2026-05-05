#!/bin/bash
# Resilient installer + updater: installs missing packages, upgrades present ones, prints a summary at the end.
set -o pipefail

INSTALLED=()
UPDATED=()
SKIPPED=()
FAILED=()

brew_install() {
  local pkg="$1"
  if brew list --formula "$pkg" >/dev/null 2>&1; then
    local output
    if output="$(brew upgrade --formula "$pkg" 2>&1)"; then
      echo "$output"
      if echo "$output" | grep -q "already installed"; then
        SKIPPED+=("$pkg (current)")
      else
        UPDATED+=("$pkg")
      fi
    else
      echo "$output"
      echo "[fail] $pkg upgrade"
      FAILED+=("$pkg")
    fi
  elif brew install "$pkg"; then
    INSTALLED+=("$pkg")
  else
    echo "[fail] $pkg"
    FAILED+=("$pkg")
  fi
}

brew_cask_install() {
  local pkg="$1"
  # Use cask name (last path component) for the install-check, since
  # `brew list --cask` doesn't accept tap-qualified names.
  local short="${pkg##*/}"
  if brew list --cask "$short" >/dev/null 2>&1; then
    local output
    if output="$(brew upgrade --cask "$short" 2>&1)"; then
      echo "$output"
      if echo "$output" | grep -qE "already installed|No installed casks"; then
        SKIPPED+=("$pkg (cask, current)")
      else
        UPDATED+=("$pkg (cask)")
      fi
    else
      echo "$output"
      echo "[fail] $pkg (cask) upgrade"
      FAILED+=("$pkg (cask)")
    fi
  elif brew install --cask --adopt "$pkg"; then
    INSTALLED+=("$pkg (cask)")
  else
    echo "[fail] $pkg (cask)"
    FAILED+=("$pkg (cask)")
  fi
}

go_get() {
  local pkg="$1"
  # Derive binary name from package path: strip @version, take last segment
  local bin_name="${pkg%@*}"
  bin_name="${bin_name##*/}"
  local gopath="${GOPATH:-$HOME/go}"
  local was_installed=0
  [ -x "$gopath/bin/$bin_name" ] && was_installed=1
  if go install "$pkg"; then
    if [ "$was_installed" -eq 1 ]; then
      UPDATED+=("go: $pkg")
    else
      INSTALLED+=("go: $pkg")
    fi
  else
    echo "[fail] go: $pkg"
    FAILED+=("go: $pkg")
  fi
}

# Homebrew
## Install (skip if already present, even if not yet on PATH)
if command -v brew >/dev/null 2>&1 || [ -x /opt/homebrew/bin/brew ] || [ -x /usr/local/bin/brew ]; then
  echo "Brew already installed, skipping."
  SKIPPED+=("homebrew")
else
  echo "Installing Brew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || true
  # Verify install succeeded even if installer's post-update step flaked
  if ! command -v brew >/dev/null 2>&1 && [ ! -x /opt/homebrew/bin/brew ] && [ ! -x /usr/local/bin/brew ]; then
    echo "[fatal] Homebrew install failed — aborting."
    exit 1
  fi
fi

# Make brew available in this shell session (Apple Silicon vs Intel paths)
if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x /usr/local/bin/brew ]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

brew analytics off || true

# Refresh package metadata so upgrades see the latest versions
echo "Updating Homebrew metadata..."
brew update || echo "[warn] brew update failed — continuing with cached metadata"

## Formulae
echo "Installing / upgrading Brew Formulae..."

########## PROGRAMMING ###########
# Editor & terminal multiplexer
brew_install neovim                         # Modern Vim
brew_install tmux                           # Terminal multiplexer

# Shell
brew_install starship                       # Prompt
brew_install zsh-autosuggestions            # Fish-like inline suggestions
brew_install zsh-syntax-highlighting        # Live command coloring

# NodeJS/TypeScript
brew_install node                           # Node.js runtime
brew_install nvm                            # Node version manager
brew_install typescript                     # TypeScript
brew_install typescript-language-server     # TS LSP
brew_install eslint_d                       # Faster eslint (for null-ls)
brew_install prettierd                      # code formatter
brew_install vscode-langservers-extracted
# Python
brew_install pyvim      # Python client for Neovim
brew_install python     # Python language
brew_install pyenv      # Python version manager
# Go
brew_install go         # Go programming language
if command -v go >/dev/null 2>&1; then
  go_get github.com/ramya-rao-a/go-outline@latest
  go_get github.com/uudashr/gopkgs/v2/cmd/gopkgs@latest
  go_get github.com/acroca/go-symbols@latest
  go_get golang.org/x/tools/gopls@latest
  go_get github.com/go-delve/delve/cmd/dlv@latest
else
  echo "[skip] go tools — go not on PATH"
fi
# Lua
brew_install lua          # Lua programming language
brew_install stylua       # Lua code formatter
brew_install luarocks     # Lua package manager
brew_install luajit       # LuaJIT compiler
# iOS / macOS
brew_install xcodes       # Xcode version manager (run: xcodes install --latest --select)

## Casks
# AeroSpace lives in a third-party tap, not the main cask repo
brew tap nikitabobko/tap >/dev/null 2>&1 || true
brew_cask_install nikitabobko/tap/aerospace       # tiling window manager for macOS
brew_cask_install karabiner-elements              # powerful keyboard customizer
brew_cask_install ghostty                         # fast, native terminal emulator
brew_cask_install orbstack                        # Docker/Linux VMs (data dir on external SSD)
brew_cask_install android-studio                  # Android IDE (SDK + AVDs on external SSD)
brew_cask_install font-hack-nerd-font             # developer-friendly font
brew_cask_install font-jetbrains-mono-nerd-font   # JetBrains Mono Nerd Font
brew_cask_install font-sf-pro                     # Apple SF Pro font

## MacOS settings
# Idempotent wrapper around `defaults write`: reads the current value first and
# skips when it already matches. Booleans normalize since `defaults read` returns
# 1/0 regardless of how it was written (TRUE/YES/etc.).
defaults_write() {
  local domain="$1" key="$2" type="$3" value="$4"
  local current expected="$value"
  current="$(defaults read "$domain" "$key" 2>/dev/null || true)"
  if [ "$type" = "-bool" ]; then
    case "$value" in
      TRUE|true|YES|yes|1) expected=1 ;;
      FALSE|false|NO|no|0)  expected=0 ;;
    esac
  fi
  if [ "$current" = "$expected" ]; then
    echo "[skip] defaults $domain $key already = $value"
    SKIPPED+=("defaults: $domain $key (current)")
    return
  fi
  if defaults write "$domain" "$key" "$type" "$value"; then
    echo "[ok] defaults $domain $key = $value"
    INSTALLED+=("defaults: $domain $key=$value")
  else
    FAILED+=("defaults: $domain $key")
  fi
}

echo "Setting macOS defaults..."
defaults_write com.apple.Dock autohide        -bool TRUE
defaults_write NSGlobalDomain KeyRepeat       -int  2
defaults_write NSGlobalDomain InitialKeyRepeat -int 10

# Symlinks
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
mkdir -p "$HOME/.config"

link_config() {
  local src="$1" dst="$2"
  if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
    echo "[skip] symlink $dst already points to $src"
    SKIPPED+=("symlink: $dst -> $src")
    return
  fi
  # ln -sfn cannot replace a non-empty real directory — it silently no-ops or
  # creates the link *inside* it. Move any pre-existing real file/dir aside so
  # the symlink actually takes effect (e.g. fresh install where an app like
  # Karabiner-Elements created ~/.config/karabiner/ before we got there).
  if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    local backup="${dst}.bak-$(date +%Y%m%d-%H%M%S)"
    if mv "$dst" "$backup"; then
      echo "[info] backed up existing $dst -> $backup"
    else
      echo "[fail] could not back up existing $dst"
      FAILED+=("symlink: $dst -> $src (backup failed)")
      return
    fi
  fi
  if ln -sfn "$src" "$dst"; then
    INSTALLED+=("symlink: $dst -> $src")
  else
    echo "[fail] symlink $dst -> $src"
    FAILED+=("symlink: $dst -> $src")
  fi
}

link_config "$DOTFILES_DIR/karabiner"       "$HOME/.config/karabiner"
link_config "$DOTFILES_DIR/ghostty"         "$HOME/.config/ghostty"
link_config "$DOTFILES_DIR/tmux"            "$HOME/.config/tmux"
link_config "$DOTFILES_DIR/starship"        "$HOME/.config/starship"
link_config "$DOTFILES_DIR/.aerospace.toml" "$HOME/.aerospace.toml"
link_config "$DOTFILES_DIR/.zshrc"          "$HOME/.zshrc"

# External SSD relocation — moves heavyweight dev tool data to /Volumes/Barandiaran.
# Two patterns are used depending on what each tool supports:
#   1. Env-var redirection (Android): tool reads $ANDROID_HOME from .zshrc → just
#      pre-create the target dirs on the SSD so the path resolves.
#   2. Symlink (iOS Simulator, etc.): tool has no env-var override → migrate any
#      existing data to the SSD and replace the original path with a symlink.
SSD_ROOT="/Volumes/Barandiaran"

# Migrate (or symlink-create) a local path into the SSD. Idempotent:
#   - already symlinked correctly → no-op
#   - real dir/file present → rsync to SSD, then symlink back
#   - nothing present → just create the symlink
relocate_to_ssd() {
  local local_path="$1" ssd_path="$2"
  if [ -L "$local_path" ] && [ "$(readlink "$local_path")" = "$ssd_path" ]; then
    echo "[skip] $local_path already → $ssd_path"
    SKIPPED+=("relocate: $local_path (current)")
    return
  fi
  mkdir -p "$ssd_path" "$(dirname "$local_path")"
  if [ -e "$local_path" ] && [ ! -L "$local_path" ]; then
    if rsync -a "$local_path/" "$ssd_path/" && rm -rf "$local_path"; then
      ln -s "$ssd_path" "$local_path"
      echo "[ok] migrated $local_path → $ssd_path"
      INSTALLED+=("relocate: $local_path → $ssd_path")
    else
      echo "[fail] migration of $local_path"
      FAILED+=("relocate: $local_path")
    fi
  else
    [ -L "$local_path" ] && rm "$local_path"
    if ln -s "$ssd_path" "$local_path"; then
      echo "[ok] symlinked $local_path → $ssd_path"
      INSTALLED+=("relocate: $local_path → $ssd_path")
    else
      echo "[fail] symlink $local_path → $ssd_path"
      FAILED+=("relocate: $local_path")
    fi
  fi
}

if [ -d "$SSD_ROOT" ] && [ -w "$SSD_ROOT" ]; then
  # Android (env-var pattern: ANDROID_HOME / ANDROID_AVD_HOME set in .zshrc)
  if [ -d "$SSD_ROOT/Dev/android/sdk" ] && [ -d "$SSD_ROOT/Dev/android/avd" ]; then
    echo "[skip] android SSD dirs already exist"
    SKIPPED+=("ssd dirs: android (current)")
  elif mkdir -p "$SSD_ROOT/Dev/android/sdk" "$SSD_ROOT/Dev/android/avd"; then
    echo "[ok] created $SSD_ROOT/Dev/android/{sdk,avd}"
    INSTALLED+=("ssd dirs: $SSD_ROOT/Dev/android/{sdk,avd}")
  else
    FAILED+=("ssd dirs: android")
  fi

  # iOS Simulator user-side data (symlink pattern — CoreSimulator has no env
  # override). Only stop the daemon if a migration is actually needed; on a
  # repeat run where the symlink is already in place we leave it alone (killing
  # it would disrupt any running simulators for nothing).
  SIM_LOCAL="$HOME/Library/Developer/CoreSimulator"
  SIM_SSD="$SSD_ROOT/Dev/ios/CoreSimulator"
  if [ ! -L "$SIM_LOCAL" ] || [ "$(readlink "$SIM_LOCAL")" != "$SIM_SSD" ]; then
    pkill -f "com.apple.CoreSimulator.CoreSimulatorService" >/dev/null 2>&1 || true
    sleep 1
  fi
  relocate_to_ssd "$SIM_LOCAL" "$SIM_SSD"
else
  echo "[skip] external SSD not mounted at $SSD_ROOT — Android/iOS relocations skipped; plug it in and re-run"
  SKIPPED+=("ssd relocations (SSD not mounted)")
fi

# Reclaim disk space from old versions left over by upgrades
echo "Cleaning up old versions..."
brew cleanup || echo "[warn] brew cleanup failed"

# Summary
echo ""
echo "================================="
echo "  Setup Summary"
echo "================================="
echo "Installed (${#INSTALLED[@]}):"
if [ "${#INSTALLED[@]}" -gt 0 ]; then
  for p in "${INSTALLED[@]}"; do echo "  + $p"; done
fi
echo ""
echo "Updated (${#UPDATED[@]}):"
if [ "${#UPDATED[@]}" -gt 0 ]; then
  for p in "${UPDATED[@]}"; do echo "  ^ $p"; done
fi
echo ""
echo "Already current / skipped (${#SKIPPED[@]}):"
if [ "${#SKIPPED[@]}" -gt 0 ]; then
  for p in "${SKIPPED[@]}"; do echo "  = $p"; done
fi
echo ""
echo "Failed (${#FAILED[@]}):"
if [ "${#FAILED[@]}" -gt 0 ]; then
  for p in "${FAILED[@]}"; do echo "  ! $p"; done
fi
echo "================================="

# Exit non-zero if anything failed (so re-runs / CI can detect issues)
if [ "${#FAILED[@]}" -gt 0 ]; then
  exit 1
fi
