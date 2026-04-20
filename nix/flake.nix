# =============================================================================
#  Robert's nix-darwin + home-manager flake
# =============================================================================
#
#  This flake defines two darwin configurations:
#
#      darwinConfigurations."personal"  → user "robert"        (isPersonalMac)
#      darwinConfigurations."work"      → user "robertmenke"   (isWorkMac)
#
#  ---------------------------------------------------------------------------
#  Day-to-day rebuilds via `nh` (https://github.com/nix-community/nh)
#  ---------------------------------------------------------------------------
#
#  `nh` is a friendlier wrapper around `darwin-rebuild` / `home-manager` /
#  `nix-collect-garbage`. It's enabled for this user in
#  `home-manager/home.nix` via `programs.nh`, which:
#
#    * installs the `nh` binary,
#    * sets $NH_FLAKE=~/dotfiles/nix so you can omit the flake path, and
#    * schedules a weekly `nh clean` run.
#
#  Because the darwin configs are named "personal"/"work" (not the machine's
#  hostname), you have to pass the configuration name with `-H`:
#
#      # Personal laptop — build, diff, confirm, activate:
#      nh darwin switch -H personal
#
#      # Work laptop:
#      nh darwin switch -H work
#
#      # From anywhere on disk, since $NH_FLAKE is set. Equivalent to the
#      # explicit form:
#      nh darwin switch ~/dotfiles/nix -H personal
#
#  Other useful `nh darwin` subcommands:
#
#      nh darwin build   -H personal     # build only, no activation
#      nh darwin test    -H personal     # activate without adding a generation
#      nh darwin rollback                # roll back to the previous generation
#      nh darwin --help                  # full reference
#
#  Add `--` to forward flags to the underlying nix build, e.g.:
#
#      nh darwin switch -H personal -- --show-trace --option eval-cache false
#
#  ---------------------------------------------------------------------------
#  Other `nh` commands worth knowing
#  ---------------------------------------------------------------------------
#
#      nh search <pkg>                   # fast Elasticsearch-backed nixpkgs search
#      nh clean all                      # GC everything (system + user profiles)
#      nh clean user --keep 5 --keep-since 7d
#                                        # GC just this user's profile (same as
#                                        # the scheduled job in home.nix)
#      nh clean user --dry               # preview what would be removed
#
#  ---------------------------------------------------------------------------
#  Updating inputs
#  ---------------------------------------------------------------------------
#
#      # Update every flake input (nixpkgs, home-manager, nix-darwin, …):
#      nix flake update --flake ~/dotfiles/nix
#
#      # Update a single input:
#      nix flake update nixpkgs --flake ~/dotfiles/nix
#
#      # Then rebuild to apply:
#      nh darwin switch -H personal       # or -H work
#
#  ---------------------------------------------------------------------------
#  Fallback without `nh`
#  ---------------------------------------------------------------------------
#
#  If `nh` is ever unavailable (e.g. first-time bootstrap on a fresh machine),
#  you can fall back to the native tools:
#
#      darwin-rebuild switch --flake ~/dotfiles/nix#personal
#      darwin-rebuild switch --flake ~/dotfiles/nix#work
#
# =============================================================================

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
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          allowUnfreePredicate = pkg: true;
          # … any of your other config
        };
      };
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
              # useGlobalPkgs = true;
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
              # useGlobalPkgs = true;
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
