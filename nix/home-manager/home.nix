{ inputs, config, pkgs, lib, isPersonalMac, isWorkMac, ... }:
let 
  # Differentiating between work and personal
  username = if isPersonalMac then "robert" else if isWorkMac then "robertmenke" else "";
  homeDirectory = if isPersonalMac then "/Users/robert" else if isWorkMac then "/Users/robertmenke" else "";
in {  
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = username;
  home.homeDirectory = homeDirectory;

  nixpkgs.overlays = [
    inputs.neovim-nightly-overlay.overlays.default
  ];

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    alacritty
    tmux
    tmuxinator
    git
    zoxide
    lsd
    bat
    direnv
    ffmpeg-full
    cachix
    jq
    starship
    ripgrep
    yazi
    imagemagick
    tealdeer
  ] ++ lib.optionals pkgs.stdenv.isDarwin [
     pkgs.yabai
     pkgs.skhd
  ];

  xdg = {
    enable = true;
    configFile = {
      ripgrep_ignore.text = ''
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
      nvim = {
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/nvim";
        recursive = true;
      };
      yabai = {
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/yabai";
        recursive = true;
      };
      skhd = {
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/skhd";
        recursive = true;
      };
      "alacritty.toml" = {
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/alacritty.toml";
      };
      "starship.toml" = {
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/starship.toml";
      };
    };
  };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
      "tmux.conf" = {
        source = ./../../tmux.conf;
        target = "${config.home.homeDirectory}/.tmux.conf";
      };
      # Symlink fish to .local/bin so that we can specify it as the default shell in .tmux.conf without reference to the username
      ".local/bin/fish" = {
        source = "${pkgs.fish}/bin/fish";
        target = "${config.home.homeDirectory}/.local/bin/fish";
      };
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/robert/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;
    # Direnv integration for flakes
    direnv.enable = true;
    direnv.nix-direnv.enable = true;
  };

  imports = [
    ./modules/git.nix
    ./modules/neovim.nix
    ./modules/fish.nix
    ./modules/bat.nix
    ./modules/ssh.nix
  ];
}
