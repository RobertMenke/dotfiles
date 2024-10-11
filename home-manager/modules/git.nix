{ pkgs, isDarwin, isLinux, ... }:
{
  programs.git = {
    enable = true;
    package = pkgs.git.override {
      guiSupport = false;
    };
    ignores = [ ".DS_Store" ".direnv/" ];
    extraConfig = {
      user = {
        name = "Robert Menke";
        email = "robert.b.menke@gmail.com";
        signingKey =
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOg7V3QuL+N+FyLxi1tCnWHz4tMzFLRSRMyLPHGcxIqI";
      };
      pull = { rebase = false; };
      commit = { gpgsign = true; };
      gpg = {
        format = "ssh";
      };
      ssh = {
        program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
      };
      core = {
        editor = "nvim";
        ignorecase = false
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
      diff = {
        colorMoved = "default";
      };
      rerere = { enabled = true; };
      fetch = { prune = true; };
      checkout = { defaultRemote = "origin"; };
      # faster git server communications
      # https://git-scm.com/docs/protocol-v2
      protocol = { version = 2; };
      url = {
        "git@gitlab.1password.io:" = {
          insteadOf = "https://gitlab.1password.io/";
        };
      };
    };
  };
}
