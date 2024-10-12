{ config, isLinux, lib, ... }:
{
  programs.ssh = {
    enable = true;
  };
}
