# =============================================================================
#  Robert's nix-darwin + home-manager flake
# =============================================================================
#
#  This flake defines two darwin configurations:
#
#      darwinConfigurations."personal"  → user "robert"
#      darwinConfigurations."work"      → user "robertmenke"
#
#  Layout:
#
#      flake.nix                # this file: inputs + mkDarwin calls
#      lib/mkDarwin.nix         # darwin-system builder (de-duped host code)
#      modules/
#        darwin/                # host-agnostic nix-darwin config
#        home/                  # host-agnostic home-manager config
#          options.nix          # `myConfig.*` options consumed by all modules
#      hosts/
#        personal/              # per-host config: myConfig values + users.users
#        work/
#      attic/                   # parking lot for unused modules
#
#  ---------------------------------------------------------------------------
#  Day-to-day rebuilds via `nh` (https://github.com/nix-community/nh)
#  ---------------------------------------------------------------------------
#
#  `nh` is a friendlier wrapper around `darwin-rebuild` / `home-manager` /
#  `nix-collect-garbage`. It's enabled in `modules/home/nh.nix`, which:
#
#    * installs the `nh` binary,
#    * sets $NH_FLAKE so you can omit the flake path (only when
#      `myConfig.dotfiles.liveSourceDir` is set), and
#    * schedules a weekly `nh clean` run.
#
#  Because the darwin configs are named "personal"/"work" (not the machine's
#  hostname), you have to pass the configuration name with `-H`:
#
#      nh darwin switch -H personal
#      nh darwin switch -H work
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
#      nh clean user --dry               # preview what would be removed
#
#  ---------------------------------------------------------------------------
#  Updating inputs
#  ---------------------------------------------------------------------------
#
#      nix flake update --flake ~/dotfiles/nix
#      nix flake update nixpkgs --flake ~/dotfiles/nix
#      nh darwin switch -H personal       # apply
#
#  ---------------------------------------------------------------------------
#  Bootstrapping a fresh machine
#  ---------------------------------------------------------------------------
#
#  Because dotfile content lives in the nix store by default (see
#  `modules/home/options.nix → myConfig.dotfiles.liveSourceDir`), a fresh
#  machine boots end-to-end with no special setup:
#
#      git clone <repo> /tmp/dotfiles
#      nix run nixpkgs#nh -- darwin switch /tmp/dotfiles/nix -H personal
#      # …then optionally move the repo and enable live-edit:
#      mv /tmp/dotfiles ~/dotfiles
#      # edit hosts/personal/default.nix → myConfig.dotfiles.liveSourceDir
#      nh darwin switch -H personal
#
#  Fallback without `nh` (only the very first rebuild needs this):
#
#      darwin-rebuild switch --flake ~/dotfiles/nix#personal
#      darwin-rebuild switch --flake ~/dotfiles/nix#work
#
# =============================================================================

{
  description = "Robert's nix-darwin + home-manager flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, ... }:
    let
      mkDarwin = import ./lib/mkDarwin.nix { inherit inputs self; };
    in
    {
      darwinConfigurations.personal = mkDarwin "personal";
      darwinConfigurations.work = mkDarwin "work";
    };
}
