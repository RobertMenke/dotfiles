{ pkgs, lib, isPersonalMac, isWorkMac, ... }: 
{
  home.sessionVariables = {
    HOMEBREW_NO_ANALYTICS = "1";
    CARGO_NET_GIT_FETCH_WITH_CLI = "true";
    GOPATH = "$HOME/go";
    TERM="xterm-256color";
  } // (if isWorkMac then {
    GITLAB_TOKEN = "op://Employee/sc3uuibeo6hjh3rwc5sy6qep4u/credential";
  } else {
    HELLO_WORLD = "hello world";
  });

  programs = {
    btop = { enable = true; };

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
        # Add default aliases
        cat="bat";
        fresh="clear && source ~/.config/fish/config.fish";
        git-recent-branches="git for-each-ref --sort=-committerdate --count=10 refs/heads/";
        git-log="git log --graph --pretty=format:'%Cred%h%Creset - %G? -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";
      } // (if isPersonalMac then {
        # Add personal aliases
        equater-up="tmuxinator start equater";
      } else if isWorkMac then {
        # Add work aliases
        tail-packaged-oph-logs="tail -f $HOME/Library/Group\ Containers/2BUA8C4S2C.com.1password/Library/Application\ Support/1Password/Data/debug/logs/1Password_rCURRENT.log";
        dbdir="z $HOME/Library/Group\ Containers/2BUA8C4S2C.com.1password/Library/Application\ Support/1Password/Data";
        deriveddata="z $HOME/Library/Developer/Xcode/DerivedData";
        dev="tmuxinator start config && tmuxinator start b5 && tmuxinator start core";
        yarn="op run --account agilebits --no-masking -- yarn";
      } else {});

      shellInit = ''
        # Source nix files, required to set fish as default shell, otherwise
        # it doesn't have the nix env vars
        # if [ -e "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh" ]
        #   fenv source "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
        # end
        # Initialize zoxide for Fish
        zoxide init fish | source
        starship init fish | source
        eval (direnv hook fish)
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
        fish_greeting = {
          description = "Override the default greeting";
          body = "";
        };
        fish_user_key_bindings = {
          description = "A function automatically invoked by fish to set up key bindings";
          body = ''
            bind \cY accept-autosuggestion
            # Press Ctrl+N to move to the next completion in the menu
            bind \cn 'commandline -f next-complete'
            # Press Ctrl+P to move to the previous completion in the menu
            bind \cp 'commandline -f previous-complete'
          '';
        };
        y = {
          description = "yazi";
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
