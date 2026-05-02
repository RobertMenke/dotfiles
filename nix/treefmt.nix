# treefmt-nix configuration
#
# Wired into the flake as `formatter.<system>` and `checks.<system>.formatting`,
# so:
#
#   nix fmt .                 # format every nix file under this flake
#   nix flake check           # also runs `treefmt --check`, failing on drift
#
# Add new languages by enabling more `programs.*` entries; see
# https://github.com/numtide/treefmt-nix#supported-programs.
{
  projectRootFile = "flake.nix";
  programs.nixfmt.enable = true;

  # attic/ is a parking lot for unused modules kept for historical
  # reference. Some of them have stale syntax that the formatter can't
  # parse; ignore the whole directory.
  settings.global.excludes = [ "attic/**" ];
}
