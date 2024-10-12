# FZF
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# NVM
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

# 1Password CLI
eval "$(op completion zsh)"; compdef _op op
