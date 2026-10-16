{ config, lib, ... }:
let
  live = config.myConfig.dotfiles.liveSourceDir;
in
{
  # Appends one more include to the Linux Ghostty entry point generated in
  # ../home/dotfiles.nix. Later `config-file`s win, so mkAfter keeps these
  # overrides after the shared config. Like `pickPath` there, the live
  # checkout is referenced directly so edits apply without a rebuild.
  xdg.configFile."ghostty/config".text = lib.mkAfter ''
    config-file = ${
      if live != null then "${live}/nix/modules/omarchy/ghostty.conf" else "${./ghostty.conf}"
    }
  '';
}
