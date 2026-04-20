{ inputs, config, pkgs, lib, ... }:
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    defaultEditor = true;
    # Adopt the new home-manager defaults (26.05+) — we don't use the
    # Ruby/Python3 providers in this config.
    withRuby = false;
    withPython3 = false;
    # package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;
    extraWrapperArgs = [
       "--set"
       "NVIM_RUST_ANALYZER"
       "${pkgs.rust-analyzer}/bin/rust-analyzer"
    ];
  };
}
