{ inputs, self }:
let
  inherit (inputs) nixpkgs nix-darwin home-manager;

  system = "aarch64-darwin";

  # ffmpeg-full 8 pulls chromaprint + kvazaar; both routinely break on darwin
  # under current nixpkgs (chromaprint/ffmpeg link; kvazaar CTest spawns ffmpeg
  # and gets SIGKILL in the nix sandbox).
  ffmpegFullDarwinWorkarounds = final: prev: {
    # tmux 3.7c makes configure abort on darwin unless a jemalloc choice is
    # given explicitly; nixpkgs c8f90650 (2026-08-22) passes neither flag.
    # Mirrors the upstream fix (nixpkgs 56d4d71, 2026-08-23); drop the
    # override once nixpkgs-unstable advances past it.
    tmux = prev.tmux.overrideAttrs (old: {
      buildInputs = (old.buildInputs or [ ]) ++ [ final.jemalloc ];
      configureFlags = (old.configureFlags or [ ]) ++ [ "--enable-jemalloc" ];
    });
    chromaprint =
      (prev.chromaprint.override {
        withTools = false;
        withExamples = false;
      }).overrideAttrs
        (_: {
          doCheck = false;
        });
    kvazaar = prev.kvazaar.overrideAttrs (_: {
      doCheck = false;
    });
    # frei0r 3.2.1 grew a hard dep on gavl, which needs Linux-only libdrm and
    # fails eval on darwin. Fixed upstream (nixpkgs 54f5c94aae, 2026-08-06);
    # drop the override once nixpkgs-unstable advances past it.
    ffmpeg-full = prev.ffmpeg-full.override { withFrei0r = false; };
  };

  pkgs = import nixpkgs {
    inherit system;
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
    overlays = [
      inputs.neovim-nightly-overlay.overlays.default
      ffmpegFullDarwinWorkarounds
    ];
  };

  configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;
in
hostName:
nix-darwin.lib.darwinSystem {
  inherit system;

  specialArgs = { inherit inputs pkgs; };

  modules = [
    ../modules/darwin
    ../hosts/${hostName}
    home-manager.darwinModules.home-manager
    {
      system.configurationRevision = configurationRevision;
      home-manager = {
        useUserPackages = true;
        backupFileExtension = "bak";
        extraSpecialArgs = { inherit inputs; };
        sharedModules = [ ../modules/home/options.nix ];
      };
    }
  ];
}
