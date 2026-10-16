# home-manager config that only makes sense on an Omarchy (Arch + Hyprland)
# host. Everything shared with the macs lives in ../home; this directory is
# for the parts of the Omarchy setup that have no mac equivalent.
{
  imports = [
    ./desktop.nix
    ./ghostty.nix
    ./hyprland.nix
    ./refind.nix
    ./shell.nix
    ./wallpapers.nix
  ];
}
