{
  config,
  lib,
  ...
}:
let
  cfg = config.myConfig.windowManager;

  aerospaceBin = "${config.services.aerospace.package}/Applications/AeroSpace.app/Contents/MacOS/AeroSpace";
in
{
  # ---------------------------------------------------------------------------
  # Tiling window manager selection.
  #
  # yabai and AeroSpace both take ownership of every window on the system, so
  # exactly one of them may run at a time. This option picks the winner and
  # wires up the matching launchd agents.
  #
  # NOTE: this is the *darwin-level* `myConfig`, distinct from the
  # home-manager-level `myConfig.*` declared in modules/home/options.nix. Set
  # it at the top level of hosts/<name>/default.nix.
  # ---------------------------------------------------------------------------
  options.myConfig.windowManager = lib.mkOption {
    type = lib.types.enum [
      "yabai"
      "aerospace"
    ];
    default = "aerospace";
    example = "yabai";
    description = ''
      Which tiling window manager to run. Every host runs AeroSpace; set this
      to "yabai" in hosts/<name>/default.nix to put a single machine back on
      the old setup.

      "aerospace" → services.aerospace, configured by
                    ../../../aerospace/aerospace.toml.
      "yabai"     → services.yabai + services.skhd, configured by
                    ../../../yabai/yabairc and ../../../skhd/skhdrc.
    '';
  };

  config = lib.mkMerge [
    {
      services.yabai = {
        enable = cfg == "yabai";
        # Requires SIP to be partially disabled; not worth it.
        enableScriptingAddition = false;
      };
      services.skhd.enable = cfg == "yabai";

      services.aerospace.enable = cfg == "aerospace";
    }

    (lib.mkIf (cfg == "aerospace") {
      # The nix-darwin module renders `services.aerospace.settings` into a TOML
      # file in the nix store and pins the daemon to it with --config-path.
      # Drop that flag so AeroSpace falls back to its default lookup of
      # ~/.config/aerospace/aerospace.toml, which modules/home/dotfiles.nix
      # symlinks straight at the repo checkout. That keeps AeroSpace in the
      # same live-edit workflow as nvim/yabai/skhd: edit the TOML, hit
      # `alt + ctrl - r` to reload, no rebuild — which is what you want while
      # the config is still in flux.
      #
      # Trade-off: the config is a plain TOML file, so it is not type-checked
      # by the module system. Move it into `services.aerospace.settings` if you
      # would rather have eval-time validation than a fast edit loop.
      launchd.user.agents.aerospace.command = lib.mkForce aerospaceBin;
    })
  ];
}
