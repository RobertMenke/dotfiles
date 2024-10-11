# FZF
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# iTerm2 shell integration
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# NVM
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

# 1Password CLI
eval "$(op completion zsh)"; compdef _op op

# Power Level 10K - To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Nix
# if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
#     . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
# fi
# End Nix
