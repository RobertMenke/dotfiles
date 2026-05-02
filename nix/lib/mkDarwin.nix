{ inputs, self }:
let
  inherit (inputs) nixpkgs nix-darwin home-manager;

  system = "aarch64-darwin";

  pkgs = import nixpkgs {
    inherit system;
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
    overlays = [
      inputs.neovim-nightly-overlay.overlays.default
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
