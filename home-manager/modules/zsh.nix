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
  };
}
