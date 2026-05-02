{ lib, pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    defaultEditor = true;
    # New home-manager defaults (26.05+); we don't use these providers.
    withRuby = false;
    withPython3 = false;
    extraWrapperArgs = [
      "--set"
      "NVIM_RUST_ANALYZER"
      "${pkgs.rust-analyzer}/bin/rust-analyzer"
    ];
  };

  # The neovim module (26.05+) generates its own init.lua at
  # ~/.config/nvim/init.lua. We manage the nvim config directory via
  # xdg.configFile.nvim (see ./dotfiles.nix), so disable the generated file
  # to avoid a collision.
  xdg.configFile."nvim/init.lua".enable = lib.mkForce false;
}
