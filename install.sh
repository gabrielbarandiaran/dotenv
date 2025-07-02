#!/bin/bash

# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Homebrew
## Install
echo "Installing Brew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew analytics off

## Taps
echo "Tapping Brew..."
brew tap homebrew/cask-fonts
brew tap FelixKratz/formulae

## Formulae
echo "Installing Brew Formulae..."

###################################
########## DEPENDENCIES ###########
###################################

########## TERMINAL ###########
brew install zsh-autosuggestions         # zsh plugin: command suggestions
brew install zsh-syntax-highlighting     # zsh plugin: syntax highlighting
brew install stow                        # dotfiles symlinker
brew install fzf                         # fuzzy finder
brew install bat                         # cat with syntax highlighting
brew install fd                          # faster alternative to find
brew install jq                          # JSON parser — super useful
brew install yq                          # YAML parser — like jq but for YAML
brew install httpie                      # Better curl for testing APIs
brew install zoxide                      # smarter cd command
brew install make                        # build automation tool
brew install qmk                         # keyboard firmware builder
brew install ripgrep                     # fast search tool

########## PROGRAMMING ###########
# NodeJS/TypeScript
brew install node                           # Node.js runtime
brew install nvm                            # Node version manager
brew install typescript                     # TypeScript
brew install typescript-language-server     # TS LSP
brew install eslint_d                       # Faster eslint (for null-ls)
brew install prettierd                      # code formatter
brew install vscode-langservers-extracted
# Python
brew install pyvim      # Python client for Neovim
brew install python     # Python language
brew install pyenv      # Python version manager
# Go
brew install go                          # Go programming language
go install github.com/ramya-rao-a/go-outline@latest         # Go outline symbols
go install github.com/uudashr/gopkgs/v2/cmd/gopkgs@latest   # Go package listing
go install github.com/acroca/go-symbols@latest              # Go symbols for LSP
go install golang.org/x/tools/gopls@latest                  # Go language server
go install github.com/go-delve/delve/cmd/dlv@latest         #
### Lua
brew install lua          # Lua programming language
brew install stylua       # Lua code formatter (via Mason or here)
brew install luarocks     # Lua package manager
brew install luajit       # LuaJIT compiler

# AWS & Cloud Tools
brew install awscli                      # AWS CLI v2
brew install aws-sam-cli                 # AWS Serverless Application Model CLI (for Lambda dev)
brew install terraform                   # Infrastructure as Code (IaC)
brew install eksctl                      # CLI for managing EKS clusters (Kubernetes on AWS)
brew install session-manager-plugin      # AWS SSM session manager plugin (needed for `aws ssm start-session`)

# Container & Kubernetes Tools
brew install --cask docker        # Docker Desktop (engine + GUI)
brew install kubectl              # Kubernetes CLI (kubectl)
brew install helm                 # Kubernetes package manager (Helm charts)
brew install k9s                  # TUI to interact with Kubernetes clusters

### Terminal
brew install git            # version control system
brew install lazygit        # terminal UI for git
brew install tmux           # terminal multiplexer
brew install neovim         # modern text editor
brew install starship       # fast customizable shell prompt
brew install tree-sitter    # incremental parsing system
brew install tree           # directory tree visualizer
brew install borders        # window border tool (macOS)

## Casks
brew install --cask aerospace                       # tiling window manager for macOS
brew install --cask karabiner-elements              # powerful keyboard customizer
brew install --cask font-hack-nerd-font             # developer-friendly font
brew install --cask font-jetbrains-mono-nerd-font   # JetBrains Mono Nerd Font
brew install --cask font-sf-pro                     # Apple SF Pro font

## MacOS settings
echo "Changing macOS defaults..."
defaults write com.apple.Dock autohide -bool TRUE
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write InitialKeyRepeat -int 10

echo "Installation complete..."

# Stow configs into ~/.config
echo "Stowing configs into ~/.config..."
stow -Rv -t ~/.config config

# Stow configs into ~
echo "Stowing configs into ~..."
stow -Rv -t ~ root

echo "Dotfiles setup complete!"
