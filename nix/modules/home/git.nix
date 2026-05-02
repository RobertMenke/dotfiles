{ config, pkgs, ... }:
let
  inherit (config.myConfig) user;
in
{
  programs.git = {
    enable = true;
    package = pkgs.git.override { guiSupport = false; };
    ignores = [ ".DS_Store" ".direnv/" ];

    # Adopt the new home-manager default (25.05+); signing is configured
    # manually below via `settings.gpg.*` using ssh.
    signing.format = null;

    settings = {
      user = {
        name = user.fullName;
        email = user.email;
        signingKey = user.signingKey;
      };
      pull = { rebase = false; };
      commit = { gpgsign = true; };
      gpg = {
        format = "ssh";
        ssh = {
          program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
        };
      };
      core = {
        editor = "nvim";
        ignorecase = false;
        pager = "${pkgs.delta}/bin/delta";
        fsmonitor = true;
        untrackedcache = true;
      };
      interactive = { diffFilter = "${pkgs.delta}/bin/delta --color-only"; };
      init = { defaultBranch = "master"; };
      delta = {
        enable = true;
        line-numbers = true;
        navigate = true;
        light = false;
      };
      merge = {
        tool = "nvim -d";
        conflictstyle = "diff3";
      };
      diff = { colorMoved = "default"; };
      rerere = { enabled = true; };
      fetch = { prune = true; };
      checkout = { defaultRemote = "origin"; };
      protocol = { version = 2; };
      url = {
        "git@gitlab.1password.io:" = {
          insteadOf = "https://gitlab.1password.io/";
        };
      };
    };
  };
}
