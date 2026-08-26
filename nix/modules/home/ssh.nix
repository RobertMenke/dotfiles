{ config, ... }:
let
  sshAuthSock = "${config.home.homeDirectory}/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock";
in
{
  programs.ssh = {
    enableDefaultConfig = false;
    enable = true;
    # Attribute names are Host patterns; keys are upstream OpenSSH directive
    # names. home-manager emits the `*` block last regardless of where it
    # appears here, so first-match-wins ordering still works out.
    settings = {
      "gitlab.1password.io" = {
        ForwardAgent = true;
        Port = 2227;
        HostName = "ssh.gitlab.1password.io";
      };
      "*.gitlab.1password.io" = {
        ForwardAgent = true;
        Port = 2227;
        HostName = "ssh.gitlab.1password.io";
      };
      "github-enterprise" = {
        HostName = "github.com";
        User = "git";
        IdentityFile = "~/.ssh/github-enterprise.pub";
        IdentitiesOnly = true;
      };
      "github.com-personal" = {
        HostName = "github.com";
        User = "git";
        IdentityFile = "~/.ssh/github-personal.pub";
        IdentitiesOnly = true;
      };
      "github-1p-public" = {
        HostName = "github.com";
        User = "git";
        IdentityFile = "~/.ssh/github-1p-public.pub";
        IdentitiesOnly = true;
      };
      "*" = {
        # The embedded quotes are load-bearing: the socket path contains a
        # space ("Group Containers").
        IdentityAgent = ''"${sshAuthSock}"'';
      };
    };
  };
}
