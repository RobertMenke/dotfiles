{ config, lib, ... }:
let
  cfg = config.myConfig.wallpaperSync;

  # Syncthing device IDs, keyed by host. They're public identifiers (a hash
  # of each machine's certificate), not secrets: pairing still needs both
  # sides to list each other. A host's ID only exists once syncthing has run
  # there; read it with `syncthing --device-id` (or the web UI at
  # http://127.0.0.1:8384) and fill it in, then rebuild both machines.
  deviceIds = {
    omarchy = "PAMQZ63-H43JFYH-3KIAJZY-VVYHGU5-DO3C4YV-KKC2MCK-YJM4JQK-KVIE6AD";
    personal = null;
  };
  devices = lib.filterAttrs (_: id: id != null) deviceIds;
in
{
  options.myConfig.wallpaperSync.enable = lib.mkEnableOption ''
    syncing ~/Pictures/Wallpapers between hosts with syncthing
  '';

  config = lib.mkIf cfg.enable {
    services.syncthing = {
      enable = true;
      settings = {
        devices = lib.mapAttrs (_: id: { inherit id; }) devices;
        # Same folder id everywhere; the path resolves to /Users/robert/...
        # on the macs and /home/robert/... on Linux.
        folders.wallpapers = {
          label = "Wallpapers";
          path = "${config.home.homeDirectory}/Pictures/Wallpapers";
          devices = builtins.attrNames devices;
        };
        # Answer the usage-reporting prompt up front (declined).
        options.urAccepted = -1;
      };
    };
  };
}
