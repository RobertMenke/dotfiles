{ configurationRevision, nixpkgs, pkgs, ... }:
{
  # imports = [ <home-manager/nix-darwin> ];
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages =
    [ 
      pkgs.vim
      pkgs.neovim
      pkgs.cargo
      pkgs.python3Full
      pkgs.php
      pkgs.nodejs_23
      pkgs.rustc
      pkgs.rustup
    ];

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # https://github.com/LnL7/nix-darwin/issues/1081#issuecomment-2394824794
  # nix.settings.always-allow-substitutes = true;

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = false;  # default shell on catalina
  programs.fish.enable = true;

  # Set Git commit hash for darwin-version.
  system.configurationRevision = configurationRevision;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";

  users.users.rbmenke = {
    name = "rbmenke";
    home = "/Users/rbmenke";
    shell = pkgs.fish;
  };
}
