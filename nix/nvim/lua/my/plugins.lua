-- [[ Configure and install plugins ]]
--
--  To check the current status of your plugins, run
--    :Lazy
--
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins, you can run
--    :Lazy update
require('lazy').setup {
  -- NOTE: Plugins can be added with a link (or for a github repo: 'owner/repo' link).
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically
  require 'my.plugins.cmp',
  require 'my.plugins.comment',
  require 'my.plugins.which-key',
  require 'my.plugins.telescope',
  require 'my.plugins.lsp-config',
  require 'my.plugins.autoformat',
  require 'my.colorschemes.kanagawa',
  require 'my.plugins.todo-comments',
  require 'my.plugins.mini',
  require 'my.plugins.treesitter',
  require 'my.plugins.neotree',
  require 'my.plugins.window-picker',
  require 'my.plugins.transparent',
  require 'my.plugins.autosave',
  require 'my.plugins.bqf',
  require 'my.plugins.treesitter-context',
  require 'my.plugins.copilot',
  require 'my.plugins.dashboard',
  require 'my.plugins.lualine',
  require 'my.plugins.neogit',
  require 'my.plugins.gitsigns',
  require 'my.plugins.indent-scope',
  require 'my.plugins.noice',
  require 'my.plugins.fidget',
  require 'my.plugins.languages.neodev',
  require 'my.plugins.diffview',
 -- require 'my.airblade.vim-rooter',
  -- Language-specific plugins
  -- Rust:
  require 'my.plugins.languages.crates',
  -- require 'my.plugins.languages.rust-tools',
  require 'my.plugins.languages.rustacean-nvim',
  -- Typescript:
  require 'my.plugins.languages.typescript',
}
