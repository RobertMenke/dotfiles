{ config, pkgs, ... }:
let
  live = config.myConfig.dotfiles.liveSourceDir;

  # `pickSource name storePath` returns either:
  #   - an out-of-store symlink to "${live}/${name}" (live edit, no rebuild
  #     needed when files change), if liveSourceDir is set, OR
  #   - the given storePath literal (a relative path resolved against this
  #     .nix file at eval time), which nix copies into /nix/store at build
  #     time. This is what makes the system bootstrap from any clone
  #     location.
  pickSource =
    name: storePath:
    if live != null then config.lib.file.mkOutOfStoreSymlink "${live}/${name}" else storePath;
in
{
  # Application configs that live in $XDG_CONFIG_HOME (~/.config).
  xdg.configFile = {
    nvim = {
      source = pickSource "nvim" ../../../nvim;
      recursive = true;
    };
    yabai = {
      source = pickSource "yabai" ../../../yabai;
      recursive = true;
    };
    skhd = {
      source = pickSource "skhd" ../../../skhd;
      recursive = true;
    };
    # AeroSpace looks here by default; modules/darwin/window-manager.nix drops
    # the --config-path flag so this file is what the daemon reads.
    aerospace = {
      source = pickSource "aerospace" ../../../aerospace;
      recursive = true;
    };
    ghostty = {
      source = pickSource "ghostty" ../../../ghostty;
      recursive = true;
    };
    "alacritty.toml".source = pickSource "alacritty.toml" ../../../alacritty.toml;
    "starship.toml".source = pickSource "starship.toml" ../../../starship.toml;
  };

  # Configs not under XDG.
  home.file = {
    "tmux.conf" = {
      source = pickSource "tmux.conf" ../../../tmux.conf;
      target = "${config.home.homeDirectory}/.tmux.conf";
    };

    # Symlink fish to .local/bin so we can hard-code it as the default shell
    # in tmux.conf without referencing the username.
    ".local/bin/fish" = {
      source = "${pkgs.fish}/bin/fish";
      target = "${config.home.homeDirectory}/.local/bin/fish";
    };

    # VSCode user settings.
    "settings.json" = {
      source = pickSource "vscode/settings.json" ../../../vscode/settings.json;
      target = "${config.home.homeDirectory}/Library/Application Support/Code/User/settings.json";
    };
    "keybindings.json" = {
      source = pickSource "vscode/keybindings.json" ../../../vscode/keybindings.json;
      target = "${config.home.homeDirectory}/Library/Application Support/Code/User/keybindings.json";
    };
  };
}
