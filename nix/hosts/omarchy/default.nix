# Omarchy (Arch + Hyprland) desktop. Unlike the darwin hosts this is a
# standalone home-manager configuration: pacman and omarchy own the OS,
# home-manager owns $HOME. See lib/mkHome.nix.
let
  username = "robert";
in
{
  imports = [
    ../../modules/home
    ../../modules/omarchy
  ];

  myConfig = {
    user = {
      username = username;
      fullName = "Robert Menke";
      email = "robert.b.menke@gmail.com";
      # Same 1Password key as the personal mac.
      signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOg7V3QuL+N+FyLxi1tCnWHz4tMzFLRSRMyLPHGcxIqI";
    };
    host = {
      role = "personal";
      isDarwin = false;
    };
    # Live-edit, like the personal mac. Omarchy itself also writes to some of
    # the files linked from here, which only works when the link points at a
    # writable checkout rather than the read-only store.
    dotfiles.liveSourceDir = "/home/${username}/dotfiles";

    # ~/Pictures/Wallpapers, kept in sync with the personal mac.
    wallpaperSync.enable = true;

    # rEFInd on the Linux ESP: Windows (blue pill) or Omarchy via Limine (red
    # pill). Built here, written to /boot by `refind-sync` (needs sudo).
    refind = {
      enable = true;
      # nvme0n1p1, the Windows ESP. `lsblk -no PARTUUID /dev/nvme0n1p1`.
      windowsPartUuid = "38a38292-1264-47bf-9eae-3016e85c3f21";
      # 10 minutes to pick an OS before the default boots.
      timeout = 600;
    };
  };
}
