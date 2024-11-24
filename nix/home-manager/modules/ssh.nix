{ config, isLinux, lib, ... }:
let
  sshAuthSock = "${config.home.homeDirectory}/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock";
in {
  programs.ssh = {
    enable = true;
      forwardAgent = true;
      matchBlocks = {
        "gitlab.1password.io" = {
          port = 2227;
          hostname = "ssh.gitlab.1password.io";
        };
        "*.gitlab.1password.io" = {
          port = 2227;
          hostname = "ssh.gitlab.1password.io";
        };
        "*" = { extraOptions = { IdentityAgent = ''"${sshAuthSock}"''; }; };
    };
  };
}
