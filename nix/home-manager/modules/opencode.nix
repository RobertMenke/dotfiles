
{ inputs, config, pkgs, lib, ... }:
{
  programs.opencode = {
    enable = true;
    settings = {
      provider = "opencode";
    };
  };
}
