{ pkgs, ... }:
let
  username = "robert";
in
{
  system.primaryUser = username;

  users.users.${username} = {
    name = username;
    home = "/Users/${username}";
    shell = pkgs.fish;
  };

  # Personal mac matches the default upstream value.
  ids.gids.nixbld = 350;

  # Back on yabai + skhd (see modules/darwin/window-manager.nix). Flip to
  # "aerospace" to switch this machine over again.
  myConfig.windowManager = "yabai";

  home-manager.users.${username} = {
    imports = [ ../../modules/home ];

    myConfig = {
      user = {
        username = username;
        fullName = "Robert Menke";
        email = "robert.b.menke@gmail.com";
        signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOg7V3QuL+N+FyLxi1tCnWHz4tMzFLRSRMyLPHGcxIqI";
      };
      host = {
        role = "personal";
        isDarwin = true;
      };
      # This host is the daily driver. Out-of-store-symlink dotfile dirs
      # from the live checkout so I can edit nvim/yabai/skhd/etc. without
      # having to rebuild for every change. Drop this back to `null` if
      # bootstrapping the same config on a new machine for the first time.
      dotfiles.liveSourceDir = "/Users/${username}/dotfiles";
    };
  };
}
