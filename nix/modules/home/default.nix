{
  config,
  inputs,
  pkgs,
  lib,
  ...
}:
let
  # Keep in sync with `lib/mkDarwin.nix`.
  ffmpegFullDarwinWorkarounds = final: prev: {
    # tmux 3.7c makes configure abort on darwin unless a jemalloc choice is
    # given explicitly; nixpkgs c8f90650 (2026-08-22) passes neither flag.
    # Mirrors the upstream fix (nixpkgs 56d4d71, 2026-08-23); drop the
    # override once nixpkgs-unstable advances past it.
    tmux = prev.tmux.overrideAttrs (old: {
      buildInputs = (old.buildInputs or [ ]) ++ [ final.jemalloc ];
      configureFlags = (old.configureFlags or [ ]) ++ [ "--enable-jemalloc" ];
    });
    chromaprint =
      (prev.chromaprint.override {
        withTools = false;
        withExamples = false;
      }).overrideAttrs
        (_: {
          doCheck = false;
        });
    kvazaar = prev.kvazaar.overrideAttrs (_: {
      doCheck = false;
    });
    # frei0r 3.2.1 grew a hard dep on gavl, which needs Linux-only libdrm and
    # fails eval on darwin. Fixed upstream (nixpkgs 54f5c94aae, 2026-08-06);
    # drop the override once nixpkgs-unstable advances past it.
    ffmpeg-full = prev.ffmpeg-full.override { withFrei0r = false; };
  };
in
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
      ffmpegFullDarwinWorkarounds
    ];
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  # Packages without first-class home-manager modules. Anything with a
  # `programs.<x>` module should go through that instead, so we get shell
  # integration for free.
  home.packages =
    with pkgs;
    [
      alacritty
      awscli2
      cachix
      claude-code
      cursor-cli
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
      tealdeer
      tmux
      tmuxinator
      tree-sitter # parser compiler for nvim-treesitter (main branch)
      uv
      yazi
    ]
    ++ lib.optionals pkgs.stdenv.isDarwin [
      yabai
      skhd
    ]
    ++ lib.optionals (config.myConfig.host.role == "personal") [
      atuin
    ];

  home.sessionPath = [
    "$HOME/.local/bin"
  ]
  ++ lib.optionals pkgs.stdenv.isDarwin [
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

    # The fish integrations for these three are wired by hand in `fish.nix`
    # instead of by their modules, because each module's version costs a
    # subprocess (or two) on every shell start:
    #
    #   direnv   - the direnv package already ships
    #              `share/fish/vendor_conf.d/direnv.fish`, which fish
    #              autoloads, so the module's hook was a second, identical
    #              one.
    #   starship - `starship init fish` prints a bootstrap that forks
    #              *another* starship for `--print-full-init`, and resolves
    #              it as bare `starship` (i.e. Homebrew's).
    #   zoxide   - `zoxide init fish` output is static per package version.
    #
    # `fish.nix` bakes the init output into the store at build time and
    # sources the resulting file.
    direnv = {
      enable = true;
      enableFishIntegration = false;
      nix-direnv.enable = true;
    };

    starship = {
      enable = true;
      enableFishIntegration = false;
    };

    zoxide = {
      enable = true;
      enableFishIntegration = false;
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
