{ config, ... }:
let
  sshAuthSock = "${config.home.homeDirectory}/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock";
in
{
  programs.ssh = {
    enableDefaultConfig = false;
    enable = true;
    matchBlocks = {
      "gitlab.1password.io" = {
        forwardAgent = true;
        port = 2227;
        hostname = "ssh.gitlab.1password.io";
      };
      "*.gitlab.1password.io" = {
        forwardAgent = true;
        port = 2227;
        hostname = "ssh.gitlab.1password.io";
      };
      "github-enterprise" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/github-enterprise.pub";
        identitiesOnly = true;
      };
      "github.com-personal" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/github-personal.pub";
        identitiesOnly = true;
      };
      "*" = {
        extraOptions = {
          IdentityAgent = ''"${sshAuthSock}"'';
        };
      };
    };
  };
}
