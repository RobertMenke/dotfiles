{ config, pkgs, lib, ... }:
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    defaultEditor = true;
    # Symlink ~/.dotfiles/nvim to ~/.config/nvim
    xdg.configFile."nvim" = "$HOME/.dotfiles/nvim";
  };
}
