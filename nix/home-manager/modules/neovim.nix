{ inputs, config, pkgs, lib, ... }:
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    defaultEditor = true;
    # package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;
  };
}
