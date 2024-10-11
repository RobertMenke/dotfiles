{ config, isLinux, lib, ... }:
{
  home.sessionVariables = { }
  programs.ssh = {
    enable = true;
  };
}
