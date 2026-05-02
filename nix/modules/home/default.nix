{ config, inputs, pkgs, lib, ... }:
{
  imports = [
    ./bat.nix
    ./dotfiles.nix
    ./fish.nix
    ./git.nix
    ./neovim.nix
    ./nh.nix
    ./ssh.nix
  ];

  # User identity is derived from myConfig so it lives in exactly one place
  # (the host file).
  home.username = config.myConfig.user.username;
  home.homeDirectory = "/Users/${config.myConfig.user.username}";

  # Pinned for compatibility with older home-manager defaults; bump
  # deliberately after reading the matching release notes.
  home.stateVersion = "24.05";

  nixpkgs = {
    overlays = [
      inputs.neovim-nightly-overlay.overlays.default
    ];
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  # Packages without first-class home-manager modules. Anything with a
  # `programs.<x>` module should go through that instead, so we get shell
  # integration for free.
  home.packages = with pkgs;
    [
      alacritty
      awscli2
      cachix
      claude-code
      cursor-cli
      direnv
      fastfetch
      ffmpeg-full
      fzf
      gh
      git
      granted
      imagemagick
      jq
      k9s
      lsd
      mirrord
      nixd
      nixfmt
      ripgrep
      ruby
      rustup
      starship
      tealdeer
      tmux
      tmuxinator
      uv
      yazi
      zoxide
    ]
    ++ lib.optionals pkgs.stdenv.isDarwin [
      yabai
      skhd
    ]
    ++ lib.optionals (config.myConfig.host.role == "personal") [
      atuin
    ];

  home.sessionPath =
    lib.optionals pkgs.stdenv.isDarwin [
      "$HOME/go/bin"
      "/Applications/Ghostty.app/Contents/MacOS"
      "$HOME/Applications/GoLand.app/Contents/MacOS"
      "/opt/homebrew/bin"
    ]
    ++ lib.optionals (config.myConfig.host.role == "work") [
      "/Users/${config.myConfig.user.username}/.dotnet/tools"
      "$HOME/.cargo/bin"
    ];

  home.sessionVariables = { };

  programs = {
    home-manager.enable = true;
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };

  xdg.enable = true;
  xdg.configFile.ripgrep_ignore.text = ''
    .git/
    yarn.lock
    package-lock.json
    packer_compiled.lua
    .DS_Store
    .netrwhist
    dist/
    node_modules/
    **/node_modules/
    wget-log
    wget-log.*
    /vendor
  '';
}
