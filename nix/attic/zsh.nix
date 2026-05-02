{ pkgs, isDarwin, isLinux, ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "github"
        "emoji"
        "docker"
        "docker-compose"
        "aws"
        "npm"
        "macos"
        "tmux"
        "zsh-autosuggestions"
        "zsh-syntax-highlighting"
        "xcode"
        "vi-mode"
        "kubectl"
      ];
    };
    shellAliases = {
      cat="bat";
      ls="exa";
      fresh="clear && source ~/.zshrc";
      equater-up="tmuxinator start equater";
      git-recent-branches="git for-each-ref --sort=-committerdate --count=10 refs/heads/";
    };
    initExtra = ''
        # Fig pre block. Keep at the top of this file.
        . "$HOME/.fig/shell/zshrc.pre.zsh"
        ####################################################
        # See ~/.oh-my-zsh/custom/*.zsh
        # related configuration
        ####################################################


        # Initialization code that may require console input (password prompts, [y/n]
        # confirmations, etc.) must go above this block; everything else may go below.
        if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
          source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
        fi

        # Which plugins would you like to load?
        # Standard plugins can be found in ~/.oh-my-zsh/plugins/*
        # Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
        # Example format: plugins=(rails git textmate ruby lighthouse)
        # Add wisely, as too many plugins slow down shell startup.
        plugins=(git github emoji docker docker-compose aws npm macos tmux xcode vi-mode kubectl) 

        # Initializing zsh
        source ~/.oh-my-zsh/oh-my-zsh.sh
        eval "$(zoxide init zsh)"
        source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

        # eval "$(starship init zsh)"
        # Fig post block. Keep at the bottom of this file.
        . "$HOME/.fig/shell/zshrc.post.zsh"

        # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
        [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
    '';
  };

  programs.starship = {
    enable = true;
    theme = "minimal";
  };
}
