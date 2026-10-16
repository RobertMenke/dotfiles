# Standalone home-manager builder, for Linux hosts where the OS is not nix
# (Omarchy/Arch). The darwin hosts get home-manager through nix-darwin in
# ./mkDarwin.nix instead.
#
# `pkgs` here is only the bootstrap set home-manager evaluates with; the
# overlays and allowUnfree live in modules/home/default.nix (`nixpkgs.*`),
# which home-manager applies on top in standalone mode.
{ inputs }:
let
  inherit (inputs) nixpkgs home-manager;
in
{ hostName, system }:
home-manager.lib.homeManagerConfiguration {
  pkgs = nixpkgs.legacyPackages.${system};
  extraSpecialArgs = { inherit inputs; };
  modules = [
    ../modules/home/options.nix
    ../hosts/${hostName}
  ];
}
