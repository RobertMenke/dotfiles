{
  description = "Robert's home manager config";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    # nixpkgs.url = "nixpkgs/release-24.05";
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      # inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      # url = "github:nix-community/home-manager/release-24.05";
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # The inputs@ syntax in the context of Nix flakes refers to function argument destructuring 
  # with named access to the entire set of arguments - e.g. can use the variable inputs which 
  # refers to the entire attribute set
  outputs = inputs@{ self, nixpkgs, nix-darwin, home-manager, ... }:
    # Just keeping this here as an example even though the let binding isn't in use right now
    let
      system = "aarch64-darwin";
      pkgs = nixpkgs.legacyPackages.${system};
      overlays = [
        inputs.neovim-nightly-overlay.overlays.default
      ];
    in {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#robert-mbp
      darwinConfigurations."personal" = nix-darwin.lib.darwinSystem {
        # inherit system;
        system = "aarch64-darwin";
        modules = [ 
          ./darwin-configuration.nix         
          home-manager.darwinModules.home-manager
          {
            nixpkgs.overlays = overlays;
            # `home-manager` config
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "bak";
              users.robert = import ./home-manager/home.nix;
              extraSpecialArgs = {
                inherit inputs pkgs;
                isDarwin = true;
                isLinux = false;
                configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;
                isPersonalMac = true;
                isWorkMac = false;
              };
            };
          }
        ];
        specialArgs = {
            inherit inputs pkgs;
            isDarwin = true;
            isLinux = false;
            configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;
            isPersonalMac = true;
            isWorkMac = false;
        };
      };

      darwinConfigurations."work" = nix-darwin.lib.darwinSystem {
        # inherit system;
        system = "aarch64-darwin";
        modules = [ 
          ./darwin-configuration.nix         
          home-manager.darwinModules.home-manager
          {
            nixpkgs.overlays = overlays;
            # `home-manager` config
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "bak";
              users.robertmenke = import ./home-manager/home.nix;
              extraSpecialArgs = {
                inherit inputs pkgs;
                isDarwin = true;
                isLinux = false;
                configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;
                isPersonalMac = false;
                isWorkMac = true;
              };
            };
          }
        ];
        specialArgs = {
            inherit inputs;
            isDarwin = true;
            isLinux = false;
            configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;
            isPersonalMac = false;
            isWorkMac = true;
        };
      };

      # Expose the package set, including overlays, for convenience.
      # darwinPackages = self.darwinConfigurations."robert-mbp".pkgs;

      # homeConfigurations."robert" = home-manager.lib.homeManagerConfiguration {
      #   inherit pkgs;
      #
      #   # Specify your home configuration modules here, for example,
      #   # the path to your home.nix.
      #   modules = [ ./home-manager/home.nix ];
      #
      #   # Optionally use extraSpecialArgs
      #   # to pass through arguments to home.nix
      #   extraSpecialArgs = {
      #       isDarwin = true;
      #       isLinux = false;
      #   };
      # };
    };
}
