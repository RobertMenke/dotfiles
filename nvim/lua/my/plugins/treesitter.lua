-- Treesitter parser management + native integration.
--
-- Neovim 0.12+ owns treesitter highlighting and indentation natively
-- (`vim.treesitter.start`, `nvim-treesitter.indentexpr`); the plugin's only
-- remaining job is installing parsers and queries. The original
-- nvim-treesitter/nvim-treesitter repo (master branch, `.configs` module)
-- was archived in April 2026 — the neovim-treesitter org fork continues the
-- `main`-branch rewrite with a community-maintained query registry.
--
-- Parser compilation requires the `tree-sitter` CLI (installed via nix, see
-- nix/modules/home/default.nix) and a C compiler.

-- Parsers beyond the ones Neovim bundles (c, lua, markdown, query, vim,
-- vimdoc). Install/update manually with :TSInstall / :TSUpdate.
local ensure_installed = {
  'bash',
  'html',
  'html_tags', -- query base inherited by html
  'typescript',
  'tsx',
  'ecma', -- query base inherited by typescript/tsx
  'jsx', -- query base inherited by tsx
  'rust',
  'kotlin',
  'swift',
  'terraform',
  'hcl',
  'yaml',
  'sql',
}

return {
  'neovim-treesitter/nvim-treesitter',
  branch = 'main',
  lazy = false,
  build = ':TSUpdate',
  -- The fork resolves parsers/queries from a community-maintained registry
  -- instead of shipping them in-repo.
  dependencies = { 'neovim-treesitter/treesitter-parser-registry' },
  config = function()
    -- Fire-and-forget async install of any missing parsers.
    require('nvim-treesitter').install(ensure_installed)

    vim.api.nvim_create_autocmd('FileType', {
      group = vim.api.nvim_create_augroup('my-treesitter-start', { clear = true }),
      desc = 'Enable treesitter highlighting and indentation when a parser exists',
      callback = function(event)
        -- pcall: silently skip filetypes without an installed parser.
        if pcall(vim.treesitter.start, event.buf) then
          vim.bo[event.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })
  end,
}
