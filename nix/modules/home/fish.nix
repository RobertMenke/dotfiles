{
  config,
  lib,
  pkgs,
  ...
}:
let
  isWork = config.myConfig.host.role == "work";
  isPersonal = config.myConfig.host.role == "personal";

  # Shell integrations are normally wired as `<tool> init fish | source`,
  # which forks a process on every shell start. starship is worse: its
  # `init` output is a bootstrap that forks a *second* starship for
  # `--print-full-init`. That output only changes when the package does, so
  # evaluate it once at build time and source a plain file at startup.
  #
  # This also pins the integration to the nix package. starship's bootstrap
  # resolves `starship` off $PATH, and `home.sessionPath` puts
  # /opt/homebrew/bin ahead of the nix profile, so the prompt was being
  # rendered by Homebrew's starship (1.18.2) rather than the one configured
  # here (1.25.1). The build sandbox has no /opt/homebrew, so baking the
  # init resolves it to the nix binary once and for all.
  bakeInit =
    name: cmd:
    pkgs.runCommand "${name}-fish-init.fish" { } ''
      ${cmd} > $out
    '';

  starshipInit = bakeInit "starship" "${lib.getExe pkgs.starship} init fish --print-full-init";
  zoxideInit = bakeInit "zoxide" "${lib.getExe pkgs.zoxide} init fish";
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
    CLOUDSMITH_API_KEY = "op://Employee/Cloudsmith API Key/credential";
    SOURCEGRAPH_ENDPOINT = "https://1password.sourcegraphcloud.com";
    SOURCEGRAPH_ACCESS_TOKEN = "op://Employee/ohojzlff6y535ahrgtr2wdcqa4/credential";
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
        # `bass` lets fish source bash scripts. The `nvm` function uses it,
        # since nvm is bash-only and not officially supported by fish — see
        # the note at https://github.com/nvm-sh/nvm#important-notes. Nothing
        # calls it during startup any more; see `shellInit`.
        {
          name = "bass";
          src = pkgs.fishPlugins.bass.src;
        }
        {
          name = "fzf-fish";
          src = pkgs.fishPlugins.fzf-fish.src;
        }
      ];

      shellAliases = {
        # `bat` is enabled in `bat.nix` (Home Manager `programs.bat`).
        cat = "bat";
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
        # direnv hooks itself in via the vendor conf.d file that ships with
        # the package; starship and zoxide are sourced from
        # `interactiveShellInit` below. See the note in `default.nix` for why
        # their Home Manager fish integrations are off.

        # Activate the default node without loading nvm.
        #
        # We used to do `bass source $NVM_DIR/nvm.sh --no-use ';' nvm use
        # default`, which cost 0.6-1.5s of *every* shell start: `bass` forks a
        # python3 to marshal the environment, that python3 forks a bash, and
        # that bash sources ~4k lines of nvm.sh before `nvm use` walks the
        # filesystem to resolve the alias.
        #
        # The only thing all of that accomplishes at startup is putting one
        # bin dir on $PATH and exporting NVM_BIN/NVM_INC, so do it directly.
        # `nvm` itself is still a function (below) that sources the real
        # nvm.sh through bass, so `nvm install`/`nvm use`/`nvm ls` are
        # unchanged — they just no longer tax shells that never call them.
        if test -d "$NVM_DIR/versions/node"
          set -l nvm_default node
          test -s "$NVM_DIR/alias/default"
            and set nvm_default (string trim <"$NVM_DIR/alias/default")

          set -l nvm_version
          if string match -qr '^v?\d+\.\d+\.\d+$' -- $nvm_default
            # Pinned exactly, e.g. `v20.17.0`.
            set nvm_version (string replace -r '^v?' v -- $nvm_default)
          else
            # `node`, `stable`, `lts/*`, a named alias... all of nvm's
            # floating aliases resolve to "newest installed" for a local
            # `nvm use`, so take that rather than reimplementing nvm's alias
            # rules here. If you pin `default` to a specific version this
            # branch is skipped entirely.
            set nvm_version (path basename $NVM_DIR/versions/node/* | sort -V | tail -1)
          end

          if test -d "$NVM_DIR/versions/node/$nvm_version/bin"
            set -gx NVM_BIN "$NVM_DIR/versions/node/$nvm_version/bin"
            set -gx NVM_INC "$NVM_DIR/versions/node/$nvm_version/include/node"
            # Strip any nvm bin dirs already on $PATH before prepending the
            # active one, so re-execs (`reload`, `nh switch`, nested shells)
            # don't stack up stale node versions the way they inherit them.
            set -gx PATH $NVM_BIN (string match -v -- "$NVM_DIR/versions/node/*" $PATH)
          end
        end
      '';

      interactiveShellInit = ''
        # Prompt and jump-around, from init output baked at build time rather
        # than regenerated by a subprocess per shell (see `bakeInit` above).
        if test "$TERM" != dumb
          source ${starshipInit}
        end
        source ${zoxideInit}

        # Faster escape / `jk` out of insert (default 300ms feels sluggish).
        set -g fish_escape_delay_ms 50

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
          body = ''
            # Skip when there is no TUI-capable tty (piping, CI, dumb TERM) so
            # we do not fight full-screen programs or non-terminals.
            test -t 1
            and test "$TERM" != dumb
            or return
            # CUP clamps to the last row, so 9999 means "the bottom" without
            # having to know the height. This used to be `tput cup $LINES`,
            # but $LINES is unreliable at startup: fish samples the terminal
            # size when it starts and does not refresh it until it handles a
            # SIGWINCH, while a GUI terminal spawns the shell against a
            # default-sized pty and applies the real window size a moment
            # later. Dropping $LINES also drops a `tput` fork per prompt.
            printf '\e[9999;1H'
          '';
        };
        # The other half of that race: if the terminal resizes *after* the
        # first prompt is drawn, the prompt is left stranded wherever the
        # small pty's bottom was. Startup got fast enough (~100ms) that we
        # now usually beat Ghostty to it, so redo the move when the real size
        # lands. Only until the first command runs -- after that
        # `_prompt_move_to_bottom` is already doing the job, and repainting
        # under the user mid-resize would be obnoxious.
        _prompt_move_to_bottom_on_resize = {
          onSignal = "WINCH";
          description = "Re-bottom the prompt when the terminal reports its real size";
          body = ''
            test -z (commandline)
            or return
            _prompt_move_to_bottom
            commandline -f repaint
          '';
        };
        _prompt_move_to_bottom_settled = {
          onEvent = "fish_preexec";
          description = "Stop chasing resizes once the shell is in use";
          body = ''
            functions -e _prompt_move_to_bottom_on_resize _prompt_move_to_bottom_settled
          '';
        };
        fresh = {
          description = "Clear the screen and re-exec fish (same env refresh as reload)";
          body = ''
            clear
            set -e __HM_SESS_VARS_SOURCED
            exec fish
          '';
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
