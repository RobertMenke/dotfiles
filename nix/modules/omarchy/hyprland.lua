-- Managed by home-manager (nix/modules/omarchy/hyprland.nix), linked to the
-- live dotfiles checkout so edits apply on save. hyprland.lua requires this
-- last, after omarchy's defaults and the stock user files.
--
-- Omarchy's own files (monitors.lua, bindings.lua, ...) stay plain files:
-- omarchy commands rewrite them with `sed -i`, which would replace a
-- home-manager symlink. Declarative overrides go here instead.

-- 4K at 2x and 144Hz. A rule for a named output beats monitors.lua's
-- catch-all, so this scale also wins over Super+/ after a reload. The
-- panel does 240Hz too, but only over an HDMI 2.1 link.
hl.monitor({ output = "HDMI-A-1", mode = "3840x2160@144", position = "auto", scale = 2 })

-- Strata as the file manager (was Nautilus). Strata itself comes from its
-- own installer at ~/.local/bin/strata, not nix.
local strata = os.getenv("HOME") .. "/.local/bin/strata"
hl.unbind("SUPER + SHIFT + F")
hl.unbind("SUPER + ALT + SHIFT + F")
o.bind("SUPER + SHIFT + F", "File manager", { launch = strata })
o.bind("SUPER + ALT + SHIFT + F", "File manager (cwd)",
  "uwsm-app -- " .. strata .. " \"$(omarchy-cmd-terminal-cwd)\"")
