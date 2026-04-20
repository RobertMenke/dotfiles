-- nixd LSP configuration.
--
-- nixd is installed via nix (see nix/home-manager/home.nix), not mason, so
-- we configure it directly against Neovim's built-in LSP client using
-- `vim.lsp.config` / `vim.lsp.enable` (the modern replacement for the
-- deprecated `require('lspconfig').<server>.setup{}` framework). See
-- `:help lspconfig-nvim-0.11`.
--
-- This module is responsible for:
--   * Deciding which darwinConfigurations entry to feed nixd (based on hostname).
--   * Pointing nixd at this repo's flake for option/attr completion across
--     nixpkgs, nix-darwin, and home-manager.
--
-- Shared LSP capabilities (cmp, folding, etc.) are assumed to be set
-- globally via `vim.lsp.config('*', { capabilities = ... })` in
-- `my.plugins.lsp-config`; they'll be merged into nixd automatically.

local M = {}

-- Where this repo's flake lives on disk. Kept as a function so it's evaluated
-- lazily at setup time (after $HOME is available).
local function flake_ref()
  return string.format('git+file://%s', vim.fn.expand('$HOME/dotfiles/nix'))
end

-- Pick which darwinConfigurations entry to evaluate. Our flake defines
-- "personal" and "work"; fall back to "personal" for anything unrecognized.
local function darwin_config_name()
  local hostname = (vim.uv and vim.uv.os_gethostname() or vim.loop.os_gethostname()) or ''
  if hostname:lower():match('work') then
    return 'work'
  end
  return 'personal'
end

local function build_settings()
  local ref = flake_ref()
  local darwin = darwin_config_name()

  return {
    nixd = {
      nixpkgs = {
        expr = string.format('import (builtins.getFlake "%s").inputs.nixpkgs { }', ref),
      },
      formatting = {
        command = { 'nixfmt' },
      },
      options = {
        nix_darwin = {
          expr = string.format(
            '(builtins.getFlake "%s").darwinConfigurations.%s.options',
            ref,
            darwin
          ),
        },
        home_manager = {
          expr = string.format(
            '(builtins.getFlake "%s").darwinConfigurations.%s.options.home-manager.users.type.getSubOptions []',
            ref,
            darwin
          ),
        },
      },
    },
  }
end

--- Register nixd with Neovim's built-in LSP client if the binary is available.
function M.setup()
  if vim.fn.executable('nixd') ~= 1 then
    return
  end

  vim.lsp.config('nixd', {
    cmd = { 'nixd' },
    filetypes = { 'nix' },
    root_markers = { 'flake.nix', 'default.nix', '.git' },
    settings = build_settings(),
  })
  vim.lsp.enable('nixd')
end

return M
