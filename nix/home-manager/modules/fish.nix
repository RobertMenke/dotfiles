{ pkgs, lib, isDarwin, isLinux, isServer, ... }: {
  home.sessionVariables = {
    HOMEBREW_NO_ANALYTICS = "1";
    CARGO_NET_GIT_FETCH_WITH_CLI = "true";
    GOPATH = "$HOME/go";
  };
  programs = {
    btop = { enable = true; };

    lsd = {
      enable = true;
      enableAliases = true;
      settings = {
        sorting = { dir-grouping = "first"; };
        icons = { when = "always"; };
        color = { when = "always"; };
      };
    };

    fish = {
      enable = true;

      plugins = [{
        name = "foreign-env";
        inherit (pkgs.fishPlugins.foreign-env) src;
      }];

      shellAliases = {
        cat="bat";
        fresh="clear && source ~/.zshrc";
        equater-up="tmuxinator start equater";
        git-recent-branches="git for-each-ref --sort=-committerdate --count=10 refs/heads/";
      };

      shellInit = ''
        # Source nix files, required to set fish as default shell, otherwise
        # it doesn't have the nix env vars
        if [ -e "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh" ]
          fenv source "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
        end
      '';

      interactiveShellInit = ''
        fish_vi_key_bindings
        bind -M insert jk "if commandline -P; commandline -f cancel; else; set fish_bind_mode default; commandline -f backward-char force-repaint; end"

        # I like to keep the prompt at the bottom rather than the top
        # of the terminal window so that running `clear` doesn't make
        # me move my eyes from the bottom back to the top of the screen;
        # keep the prompt consistently at the bottom
        _prompt_move_to_bottom # call function manually to load it since event handlers don't get autoloaded
      '';

      functions = {
        fish_greeting = "";
        _prompt_move_to_bottom = {
          onEvent = "fish_postexec";
          body = "tput cup $LINES";
        };
      };
    };
  };

  home.packages = with pkgs; [ cachix jq ];
}
