{ config, lib, ... }:
let
  live = config.myConfig.dotfiles.liveSourceDir;
in
{
  # nh - friendlier CLI wrapper around nix-darwin/home-manager.
  # Usage examples live in nix/flake.nix's header comment.
  programs.nh = {
    enable = true;

    # If a live dotfiles dir is configured, point nh at the flake inside
    # it so commands like `nh darwin switch -H personal` work from
    # anywhere. On a fresh-bootstrap machine where liveSourceDir is null,
    # leave `flake` unset — you'd pass the flake path explicitly:
    #   nh darwin switch /tmp/dotfiles/nix -H personal
    flake = lib.mkIf (live != null) "${live}/nix";

    clean = {
      enable = true;
      extraArgs = "--keep 5 --keep-since 7d";
    };
  };
}
