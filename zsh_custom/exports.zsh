
# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=/Users/rbmenke/Library/Python/3.8/bin:$PATH
# Path to your oh-my-zsh installation.
export ZSH="/Users/rbmenke/.oh-my-zsh"
# Default editor
export EDITOR='nvim'
# Set the path to the default path before appending anything. This ensures that I can source ~/.bash_profile in the
# same terminal window as many times as I want without unintended consequences
export PATH="$(getconf PATH)":/usr/local/bin

# Python 3.4
export PATH=$PATH:"/Library/Frameworks/Python.framework/Versions/3.4/bin:${PATH}"

# Go Path
export PATH=$PATH:/usr/local/opt/go/libexec/bin
export GOPATH=$HOME/golang
export PATH=$PATH:$GOPATH/bin

# Rust Path
export RUSTPATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"

# Android react native stuff
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/platform-tools

# NPM
export PATH="$HOME/.npm-packages/bin:$PATH"

# Flutter
export PATH="/usr/local/bin/flutter/bin:$PATH"

# Homebrew
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/opt/homebrew/sbin:$PATH"

# LunarVim
export PATH="/Users/rbmenke/.local/bin:$PATH"

# Heroku CLI
export PATH="/opt/homebrew/Cellar/heroku/7.60.2:$PATH"

# NVM setup - ensure this is run after the path is configured
export NVM_DIR=~/.nvm
source ~/.nvm/nvm.sh
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"

# Necessary to explicitly export this as of tmux 3.3 https://github.com/tmux/tmux/issues/3203
export TERM=xterm-256color

export PATH="$PATH:$HOME/.1password"

# Equater CLI
export EQUATER_API_BASE=https://www.equater.io
export EQUATER_LOCAL_DATABASE_URL=file:$HOME/.local/share/Equater/equater_cli.db

# Nix
export PATH="$PATH:/nix/var/nix/profiles/default/bin"
export PATH="$PATH:/Users/rbmenke/.nix-profile/bin"
export PATH="$PATH:/run/current-system/sw/bin"


