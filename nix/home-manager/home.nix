{ config, pkgs, lib, ... }:
{  
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "rbmenke";
  home.homeDirectory = "/Users/rbmenke";
  # home.homeDirectory = lib.mkForce "/Users/rbmenke";

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
    git
    zoxide
    lsd
    bat
    direnv
    ffmpeg-full
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
      ".config/nvim" = {
        source = "${config.home.homeDirectory}/.dotfiles/nvim";
        target = "${config.home.homeDirectory}/.config/nvim";
      };
      yabai = {
        source = "${config.home.homeDirectory}/.dotfiles/yabai";
        target = "${config.home.homeDirectory}/.config/yabai";
      };
      skhd = {
        source = "${config.home.homeDirectory}/.dotfiles/skhd";
        target = "${config.home.homeDirectory}/.config/skhd";
      };
      "alacritty.toml" = {
        source = "${config.home.homeDirectory}/.dotfiles/alacritty.toml";
        target = "${config.home.homeDirectory}/.config/alacritty.toml";
      };
      "starship.toml" = {
        source = "${config.home.homeDirectory}/.dotfiles/starship.toml";
        target = "${config.home.homeDirectory}/.config/starship.toml";
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
  #  /etc/profiles/per-user/rbmenke/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  imports = [
    ./modules/git.nix
    ./modules/neovim.nix
    ./modules/fish.nix
    ./modules/bat.nix
    ./modules/ssh.nix
  ];
}
