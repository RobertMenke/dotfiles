{ config, lib, ... }:
let
  live = config.myConfig.dotfiles.liveSourceDir;
  hyprlandLua = "${config.xdg.configHome}/hypr/hyprland.lua";
  requireLine = ''pcall(require, "hypr.nix") -- home-manager overrides (nix/modules/omarchy/hyprland.nix)'';
in
{
  xdg.configFile = {
    # Live symlink, like the other dotfiles, so Hyprland reloads on save.
    "hypr/nix.lua".source =
      if live != null then
        config.lib.file.mkOutOfStoreSymlink "${live}/nix/modules/omarchy/hyprland.lua"
      else
        ./hyprland.lua;

    # Strata answers "Open file" dialogs; GTK's picker is the fallback when
    # Strata isn't installed. Replaces the file Strata's installer writes.
    "xdg-desktop-portal/hyprland-portals.conf".text = ''
      [preferred]
      default=hyprland;gtk
      org.freedesktop.impl.portal.FileChooser=strata;hyprland;gtk;
    '';
  };

  home.activation = {
    # hyprland.lua belongs to omarchy (it's rewritten by `omarchy refresh
    # hyprland`), so rather than owning it, make sure it loads hypr/nix.lua
    # last. pcall keeps Hyprland starting if the file is ever missing.
    hyprlandRequireNix = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      # Not `run`: under --dry-run it would echo into the redirect target.
      if [[ ! -v DRY_RUN && -f ${hyprlandLua} ]] && ! grep -qF 'require, "hypr.nix")' ${hyprlandLua}; then
        verboseEcho "Adding hypr.nix require to ${hyprlandLua}"
        printf '\n%s\n' ${lib.escapeShellArg requireLine} >> ${hyprlandLua}
      fi
    '';

    # Folders open in Strata. mimeapps.list stays a plain file because other
    # apps (browsers, xdg-settings) write their own defaults into it.
    strataDefaultFileManager = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      if [[ -f ${config.xdg.dataHome}/applications/io.github.lgse.Strata.desktop ]]; then
        run /usr/bin/xdg-mime default io.github.lgse.Strata.desktop inode/directory
      fi
    '';
  };
}
