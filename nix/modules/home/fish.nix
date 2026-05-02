{
  config,
  lib,
  pkgs,
  ...
}:
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
    # nvm's installer puts everything under ~/.nvm by default; this matches
    # that. Override at install time (NVM_DIR=~/.config/nvm bash <install>)
    # if you ever want the XDG location instead.
    NVM_DIR = "$HOME/.nvm";
  }
  // lib.optionalAttrs isWork {
    GITLAB_TOKEN = "op://Employee/olmsgg4xktttuz5bpeefp7dj6q/credential";
    GOPRIVATE = "go.1password.io,gitlab.1password.io,proto.1infra.dev,github.com/agilebits-inc";
  };

  programs = {
    btop.enable = true;

    lsd = {
      enable = true;
      enableFishIntegration = true;
      settings = {
        sorting = {
          dir-grouping = "first";
        };
        icons = {
          when = "always";
        };
        color = {
          when = "always";
        };
      };
    };

    fish = {
      enable = true;

      plugins = [
        # `bass` lets fish source bash scripts. We use it to load nvm, which
        # is bash-only and not officially supported by fish — see the note at
        # https://github.com/nvm-sh/nvm#important-notes.
        {
          name = "bass";
          src = pkgs.fishPlugins.bass.src;
        }
      ];

      shellAliases = {
        cat = "bat";
        fresh = "clear && source ~/.config/fish/config.fish";
        git-recent-branches = "git for-each-ref --sort=-committerdate --count=10 refs/heads/";
        git-log = "git log --graph --pretty=format:'%Cred%h%Creset - %G? -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";
      }
      // lib.optionalAttrs isPersonal {
        equater-up = "tmuxinator start equater";
      }
      // lib.optionalAttrs isWork {
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

        # Load nvm via bass (nvm is bash-only, see
        # https://github.com/nvm-sh/nvm#important-notes). Sourcing nvm.sh
        # activates the default node version (set via `nvm alias default
        # <version>`) and puts node/npm on PATH for this fish session.
        if test -s "$NVM_DIR/nvm.sh"
          bass source "$NVM_DIR/nvm.sh" --no-use
          # Activate the default version if one is set; otherwise fall back
          # to whatever's currently linked under $NVM_DIR/versions/node.
          if test -e "$NVM_DIR/alias/default"
            bass source "$NVM_DIR/nvm.sh" ';' nvm use default --silent >/dev/null 2>&1
          end
        end
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
        nvm = {
          description = "Run nvm (a bash-only tool) from fish via bass";
          body = ''
            if not test -s "$NVM_DIR/nvm.sh"
              echo "nvm: $NVM_DIR/nvm.sh not found. Install nvm: https://github.com/nvm-sh/nvm#installing-and-updating" >&2
              return 1
            end
            bass source "$NVM_DIR/nvm.sh" --no-use ';' nvm $argv
          '';
        };
        reload = {
          description = "Re-exec fish, picking up the new generation's session vars";
          body = ''
            # home-manager guards `hm-session-vars.fish` with an *exported*
            # `__HM_SESS_VARS_SOURCED` variable so it only sources once per
            # shell. `exec fish` inherits that guard from the parent, so
            # without erasing it here the new shell would skip session-var
            # setup and keep stale values for $NVM_DIR, $PATH, etc.
            set -e __HM_SESS_VARS_SOURCED
            exec fish
          '';
        };
        nh = {
          description = "Wrap nh; auto-reload fish after a successful switch/rollback so new session vars / PATH take effect";
          body = ''
            command nh $argv
            set -l rc $status

            # A child process cannot mutate its parent shell's environment,
            # so after a successful generation flip we re-exec fish in place.
            # This preserves the terminal/tmux pane but re-runs config.fish,
            # picks up the new $PATH, $NVM_DIR, hm-session-vars, etc.
            #
            # We `set -e __HM_SESS_VARS_SOURCED` first because home-manager
            # guards hm-session-vars.fish with that exported flag — without
            # erasing it, the new shell would skip session-var setup and
            # inherit stale values from the parent.
            if test $rc -eq 0
              and begin
                contains -- switch $argv
                or contains -- rollback $argv
              end
              echo
              echo "  reloading fish to pick up new session vars..."
              set -e __HM_SESS_VARS_SOURCED
              exec fish
            end

            return $rc
          '';
        };
      };
    };
  };
}
