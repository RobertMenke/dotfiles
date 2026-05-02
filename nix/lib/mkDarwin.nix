{ inputs, self }:
let
  inherit (inputs) nixpkgs nix-darwin home-manager;

  system = "aarch64-darwin";

  # ffmpeg-full 8 pulls chromaprint + kvazaar; both routinely break on darwin
  # under current nixpkgs (chromaprint/ffmpeg link; kvazaar CTest spawns ffmpeg
  # and gets SIGKILL in the nix sandbox).
  ffmpegFullDarwinWorkarounds = final: prev: {
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
