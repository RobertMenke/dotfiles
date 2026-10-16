{ config, lib, ... }:
let
  synced = "${config.home.homeDirectory}/Pictures/Wallpapers";
  userBackgrounds = "${config.xdg.configHome}/omarchy/backgrounds";
in
{
  # Omarchy looks for extra backgrounds per theme in
  # ~/.config/omarchy/backgrounds/<theme>/ and follows symlinks there, so
  # point every theme at the synced folder (../home/syncthing.nix):
  # `omarchy theme bg next` then cycles through the shared collection on top
  # of the theme's own art. A theme that already has its own backgrounds
  # directory is left alone. Themes installed later get linked on the next
  # switch.
  home.activation.wallpaperLinks = lib.mkIf config.myConfig.wallpaperSync.enable (
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      run mkdir -p ${synced} ${userBackgrounds}
      for theme in /usr/share/omarchy/themes/* ${config.xdg.configHome}/omarchy/themes/*; do
        [[ -d $theme ]] || continue
        link=${userBackgrounds}/$(basename "$theme")
        [[ -e $link || -L $link ]] || run ln -s ${synced} "$link"
      done
    ''
  );
}
