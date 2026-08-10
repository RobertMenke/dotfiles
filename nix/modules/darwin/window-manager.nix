{
  config,
  lib,
  ...
}:
let
  cfg = config.myConfig.windowManager;

  aerospaceBin = "${config.services.aerospace.package}/Applications/AeroSpace.app/Contents/MacOS/AeroSpace";
  yabaiBin = "${config.services.yabai.package}/bin/yabai";
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
      Which tiling window manager to run. Every host sets this explicitly in
      hosts/<name>/default.nix; both are currently on "yabai". The default
      below only applies to a host that has not yet made a choice.

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

    (lib.mkIf (cfg == "yabai") {
      # -----------------------------------------------------------------------
      # Verbose logging, to catch the unmanaged-window bug in the act.
      #
      # Symptom being hunted (asmvik/yabai#2464, my #2818): a window shows up
      # in `query --windows` with "role":"" and "has-ax-reference":false, floats
      # above the tiled windows, and `yabai -m window <id> --focus` answers
      # "could not locate the window to act on!". The cause line only exists in
      # the --verbose stream ("ignoring AXUnknown window ..."), so verbose has
      # to already be running when it strikes.
      #
      # Two traps this setup avoids:
      #
      #  1. yabai's signal machinery forks to run signal commands, and the
      #     child exits through exit(3), which flushes an inherited copy of the
      #     parent's stdio buffer. Plain StandardOutPath makes stdout fully
      #     buffered, so with the space_changed signals in yabai/yabairc every
      #     space switch would replay a chunk of earlier log lines and the log
      #     would lie about event order. Running yabai under script(1) gives it
      #     a pty, stdout becomes line buffered, and there is nothing in the
      #     buffer to replay. The binary stays stock, which keeps any captured
      #     log credible upstream.
      #
      #  2. script(1) truncates its output file on start, and the reflex when a
      #     window gets stuck is `alt + ctrl + shift - r`, which would erase
      #     the evidence. A timestamped filename per (re)start means the log
      #     that matters survives the restart that fixes the symptom.
      #
      # When it happens, before restarting anything:
      #     yabai -m query --windows > /tmp/stuck-windows.json
      #     yabai -m window <id> --focus   # capture the error text
      #     ls -t /tmp/yabai-verbose-*     # newest file has the cause line
      # The pty writes CRLF line endings; strip them when extracting:
      #     tr -d '\r' < /tmp/yabai-verbose-<ts>.log | grep <window-id>
      #
      # Logs live in /tmp on purpose: cleared every boot, so they cannot pile
      # up forever. Expect tens of MB on a busy day; truncate with
      # `: > /tmp/yabai-verbose-<ts>.log` if one gets annoying (APFS keeps the
      # hole sparse).
      # -----------------------------------------------------------------------
      launchd.user.agents.yabai.serviceConfig.ProgramArguments = lib.mkForce [
        "/bin/sh"
        "-c"
        ''exec /usr/bin/script -q "/tmp/yabai-verbose-$(date +%Y%m%d-%H%M%S).log" ${yabaiBin} --verbose''
      ];
    })

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
