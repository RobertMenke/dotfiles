{ pkgs, ... }:
let
  username = "robertmenke";
in
{
  system.primaryUser = username;

  users.users.${username} = {
    name = username;
    home = "/Users/${username}";
    shell = pkgs.fish;
  };

  # Hack to avoid having to uninstall the existing nix install on the work mac.
  ids.gids.nixbld = 30000;

  # Matches the personal mac (see modules/darwin/window-manager.nix). Flip to
  # "aerospace" to switch this machine over again.
  myConfig.windowManager = "yabai";

  home-manager.users.${username} = {
    imports = [ ../../modules/home ];

    myConfig = {
      user = {
        username = username;
        fullName = "Robert Menke";
        email = "robert.menke@agilebits.com";
        signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE18t5Zu74f0MuYAC01F9Fj9bVMlnrYBL/DDvEhJ2jYp";
      };
      host = {
        role = "work";
        isDarwin = true;
      };
      # Bootstrappable from any clone location by default. To enable
      # live-edit on this machine, set:
      #   dotfiles.liveSourceDir = "/Users/${username}/dotfiles";
    };
  };
}
