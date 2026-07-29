{ pkgs, ... }:
{
  # System-level config that's identical across hosts. Per-host bits
  # (system.primaryUser, users.users.<name>, ids.gids.nixbld) live in
  # hosts/<name>/default.nix.

  # Window manager. Defaults to AeroSpace on every host; override with
  # `myConfig.windowManager = "yabai"` in a host file.
  imports = [ ./window-manager.nix ];

  environment.systemPackages = with pkgs; [
    rustup
    go
  ];

  nix.package = pkgs.nix;
  nix.settings.experimental-features = "nix-command flakes";

  programs.zsh.enable = false;
  programs.fish.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;

  nixpkgs.hostPlatform = "aarch64-darwin";

  fonts.packages = with pkgs; [ nerd-fonts.jetbrains-mono ];
}
