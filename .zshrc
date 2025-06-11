# export PATH=$HOME/bin:/usr/local/bin:$PATH
#echo source ~/.bash_profile

PATH=$PATH:/opt/homebrew/bin

eval "$(brew shellenv)"

# Add local ~/scripts to the PATH
export PATH="$HOME/.config/scripts:$PATH"

export PATH="$HOME/.local/share/nvim/mason/bin:$PATH"

export TMUX_CONF=~/.config/tmux/tmux.conf

# Set XDG config home
export XDG_CONFIG_HOME="$HOME/.config"

# NVM 
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# Go Path
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$PATH
export PATH=$PATH:$(go env GOPATH)/bin

# Path to your oh-my-zsh installation.
# NOTE : Disabled Shell Prompt: Currently using Starship
export ZSH="$HOME/.oh-my-zsh"

# HACK: zsh plugins
plugins=(
    git
    web-search
)

source $ZSH/oh-my-zsh.sh

# Starship 
eval "$(starship init zsh)"
# set Starship PATH
export STARSHIP_CONFIG=$HOME/.config/starship/starship.toml

# NOTE: Zoxide
eval "$(zoxide init zsh)"

# NOTE: FZF
eval "$(fzf --zsh)"

export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git "
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

export FZF_DEFAULT_OPTS="--height 50% --layout=default --border --color=hl:#2dd4bf"

# Setup fzf previews
export FZF_CTRL_T_OPTS="--preview 'bat --color=always -n --line-range :500 {}'"
export FZF_ALT_C_OPTS="--preview 'eza --icons=always --tree --color=always {} | head -200'"

# fzf preview for tmux
export FZF_TMUX_OPTS=" -p90%,70% "  

# FZF with Git right in the shell by Junegunn : check out his github below
source ~/.config/scripts/fzf-git.sh

. "$HOME/.atuin/bin/env"

# Atuin Configs
eval "$(atuin init zsh)"
# Keybinding to start Atuin in Insert Mode
bindkey '^r' atuin-search-viins  # Ctrl-r starts Atuin in Insert mode

#User configuration
# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Console Ninja
PATH=~/.console-ninja/.bin:$PATH


# These alias need to have the same exact space as written here
# HACK: For Running Go Server using Air
alias air='$(go env GOPATH)/bin/air'

# other Aliases shortcuts
alias c="clear"
alias e="exit"

# Tmux 
alias tmux="tmux -f $TMUX_CONF"
alias a="attach"

# fzf 
alias nlof="~/.config/scripts/fzf_listoldfiles.sh"
# opens documentation through fzf (eg: git,zsh etc.)
alias fman="compgen -c | fzf | xargs man"

# Next level of an ls 
alias ls="eza --no-filesize --long --color=always --icons=always --no-user" 

# tree
alias tree="tree -L 3 -a -I '.git' --charset X "
alias dtree="tree -L 3 -a -d -I '.git' --charset X "

# git aliases
alias gt="git"
alias ga="git add ."
alias gs="git status -s"
alias gc='git commit -m'
alias glog='git log --oneline --graph --all'
alias gh-create='gh repo create --private --source=. --remote=origin && git push -u --all && gh browse'

# lazygit
alias lg="lazygit"

# unbind ctrl g in terminal
bindkey -r "^G"

# brew installations activation (new mac systems brew path: opt/homebrew , not usr/local )
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
