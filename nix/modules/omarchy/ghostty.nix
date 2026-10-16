{ lib, ... }:
{
  # Appends omarchy's ghostty settings to the Linux entry point generated in
  # ../home/dotfiles.nix, after the shared config so they win. Inlined, not
  # `config-file`d, for the reason given there: included files override
  # command-line flags, which broke omarchy's screensaver. Editing
  # ghostty.conf therefore needs a switch.
  #
  # Only omarchy's theme file stays an include; it sets colors, which no
  # caller passes on the command line.
  xdg.configFile."ghostty/config".text = lib.mkAfter ''

    # --- Omarchy layer (nix/modules/omarchy/ghostty.conf) ---
    ${builtins.readFile ./ghostty.conf}
  '';
}
