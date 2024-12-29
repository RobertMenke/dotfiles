{ configurationRevision, nixpkgs, pkgs, isWorkMac, isPersonalMac, ... }:
let 
  username = if isPersonalMac then "robert" else if isWorkMac then "robertmenke" else "";
  shellConfig = {
      name = username;
      home = "/Users/${username}";
      shell = pkgs.fish;
  };
in {
  # imports = [ <home-manager/nix-darwin> ];
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs;
    [ 
      vim
      neovim
      python3Full
      php
      nodePackages.nodejs
      rustup
      go
    ];

  # Enable yabai and skhd services
  # https://github.com/LnL7/nix-darwin/blob/f0dd0838c3558b59dc3b726d8ab89f5b5e35c297/modules/services/yabai/default.nix#L44
  services = {
     yabai = {
      enable = true;
      enableScriptingAddition = false;
    };
    skhd.enable = true;
  };


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

  
  fonts.packages = with pkgs; [ nerdfonts ];

  users.users = (if isPersonalMac then {
      robert = shellConfig;
    } else if isWorkMac then {
      robertmenke = shellConfig;
    } else {}
  );
  # users.users.${username} = {
  #   name = username;
  #   home = "/Users/${username}";
  #   shell = pkgs.fish;
  # };
}
