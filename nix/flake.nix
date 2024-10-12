{
  description = "Robert's home manager config";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "nixpkgs/release-24.05";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nix-darwin, home-manager, ... }:
    let
      system = "aarch64-darwin";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#MacBook-Pro-60
      darwinConfigurations."robert-mbp" = nix-darwin.lib.darwinSystem {
        modules = [ ./darwin-configuration.nix ];
        extraSpecialArgs = {
            isDarwin = true;
            isLinux = false;
        };
      };

      # Expose the package set, including overlays, for convenience.
      darwinPackages = self.darwinConfigurations."robert-mbp".pkgs;

      homeConfigurations."rbmenke" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [ ./home-manager/home.nix ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
        extraSpecialArgs = {
            isDarwin = true;
            isLinux = false;
        };
      };
    };
}
