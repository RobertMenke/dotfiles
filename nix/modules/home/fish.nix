{ config, lib, pkgs, ... }:
let
  isWork = config.myConfig.host.role == "work";
  isPersonal = config.myConfig.host.role == "personal";
in
{
  home.sessionVariables = {
    HOMEBREW_NO_ANALYTICS = "1";
    CARGO_NET_GIT_FETCH_WITH_CLI = "true";
    GOPATH = "$HOME/go";
    TERM = "xterm-256color";
    NVM_DIR = "$HOME/.config/nvm";
  } // lib.optionalAttrs isWork {
    GITLAB_TOKEN = "op://Employee/olmsgg4xktttuz5bpeefp7dj6q/credential";
    GOPRIVATE = "go.1password.io,gitlab.1password.io,proto.1infra.dev,github.com/agilebits-inc";
  };

  programs = {
    btop.enable = true;

    lsd = {
      enable = true;
      enableFishIntegration = true;
      settings = {
        sorting = { dir-grouping = "first"; };
        icons = { when = "always"; };
        color = { when = "always"; };
      };
    };

    fish = {
      enable = true;

      shellAliases = {
        cat = "bat";
        fresh = "clear && source ~/.config/fish/config.fish";
        git-recent-branches = "git for-each-ref --sort=-committerdate --count=10 refs/heads/";
        git-log = "git log --graph --pretty=format:'%Cred%h%Creset - %G? -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";
      } // lib.optionalAttrs isPersonal {
        equater-up = "tmuxinator start equater";
      } // lib.optionalAttrs isWork {
        tail-packaged-oph-logs = "tail -f $HOME/Library/Group Containers/2BUA8C4S2C.com.1password/Library/Application Support/1Password/Data/debug/logs/1Password_rCURRENT.log";
        dbdir = "z $HOME/Library/Group\\ Containers/2BUA8C4S2C.com.1password/Library/Application\\ Support/1Password/Data";
        deriveddata = "z $HOME/Library/Developer/Xcode/DerivedData";
        dev = "tmuxinator start config && tmuxinator start b5 && tmuxinator start core";
        yarn = "op run --account agilebits --no-masking -- yarn";
      };

      shellInit = ''
        # zoxide / starship are still initialized manually here. Once we move
        # them onto the `programs.zoxide` / `programs.starship` HM modules
        # (Tier 2), these two lines become unnecessary.
        zoxide init fish | source
        starship init fish | source
        eval (direnv hook fish)
      '';

      interactiveShellInit = ''
        fish_vi_key_bindings
        bind -M insert jk "if commandline -P; commandline -f cancel; else; set fish_bind_mode default; commandline -f backward-char force-repaint; end"

        # Keep the prompt at the bottom of the terminal so that running
        # `clear` doesn't move my eyes from the bottom back to the top.
        _prompt_move_to_bottom
      '';

      functions = {
        fish_greeting = {
          description = "Override the default greeting";
          body = "";
        };
        fish_user_key_bindings = {
          description = "Set up custom key bindings";
          body = ''
            bind \cY accept-autosuggestion
            bind \cn 'commandline -f next-complete'
            bind \cp 'commandline -f previous-complete'
          '';
        };
        y = {
          description = "yazi with cwd-tracking";
          body = ''
            set tmp (mktemp -t "yazi-cwd.XXXXXX")
            yazi $argv --cwd-file="$tmp"
            if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
              builtin cd -- "$cwd"
            end
            rm -f -- "$tmp"
          '';
        };
        _prompt_move_to_bottom = {
          onEvent = "fish_postexec";
          body = "tput cup $LINES";
        };
      };
    };
  };
}
