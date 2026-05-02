{ lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  # ---------------------------------------------------------------------------
  # myConfig.* — host-level options shared across home-manager modules.
  #
  # Defined here so every module under modules/home/ can read e.g.
  # `config.myConfig.user.email` instead of branching on flat boolean
  # arguments like `isPersonalMac` / `isWorkMac`. Per-host values are set in
  # hosts/<name>/default.nix.
  # ---------------------------------------------------------------------------
  options.myConfig = {
    user = {
      username = mkOption {
        type = types.str;
        description = "Local Unix username on this machine.";
      };
      fullName = mkOption {
        type = types.str;
        description = "Display name used for git, SSH key comments, etc.";
      };
      email = mkOption {
        type = types.str;
        description = "Primary email used for git commit author/committer.";
      };
      signingKey = mkOption {
        type = types.str;
        description = "SSH public key used by 1Password to sign commits.";
      };
    };

    host = {
      role = mkOption {
        type = types.enum [
          "personal"
          "work"
        ];
        description = "High-level identity of this host. Drives a few branches.";
      };
      isDarwin = mkOption {
        type = types.bool;
        default = true;
        description = "Whether this host is macOS. Linux support is aspirational.";
      };
    };

    dotfiles = {
      liveSourceDir = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "/Users/robert/dotfiles";
        description = ''
          Absolute path to a checkout of this dotfiles repo on disk.

          When set, dotfile directories (nvim, yabai, skhd, ghostty, etc.)
          are out-of-store-symlinked from this location, giving you live
          editing without rebuilds.

          When null (default), dotfile content is copied into the nix store
          at build time, making the system bootstrappable from any clone
          location with a single `nh darwin switch` invocation.
        '';
      };
    };
  };
}
