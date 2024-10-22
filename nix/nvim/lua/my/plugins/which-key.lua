-- NOTE: Plugins can also be configured to run lua code when they are loaded.
--
-- This is often very useful to both group configuration, as well as handle
-- lazy loading plugins that don't need to be loaded immediately at startup.
--
-- For example, in the following configuration, we use:
--  event = 'VimEnter'
--
-- which loads which-key before all the UI elements are loaded. Events can be
-- normal autocommands events (`:help autocmd-events`).
--
-- Then, because we use the `config` key, the configuration only runs
-- after the plugin has been loaded:
--  config = function() ... end
local git = require 'my.utils.git'
local fs = require 'my.utils.filesystem'
local neotreeUtil = require 'my.utils.neotree'
local function format()
  require('conform').format { async = true, lsp_fallback = true }
end

return { -- Useful plugin to show you pending keybinds.
  'folke/which-key.nvim',
  event = 'VimEnter', -- Sets the loading event to 'VimEnter'
  keys = {
    { '<leader>c', group = '[C]ode' },
    { '<leader>d', group = '[D]ocument' },
    { '<leader>r', group = '[R]ename' },
    { '<leader>s', group = '[S]earch' },
    { '<leader>w', group = '[W]orkspace' },
    { '<leader>cb', fs.CopyBufferName, desc = '[C]opy buffer path + name' },
    { '<leader>cc', ':e $MYVIMRC <CR>', desc = '[C]onfig' },
    { '<leader>cd', '<cmd>Telescope diagnostics bufnr=0 theme=get_ivy<cr>', desc = 'Buffer [D]iagnostics' },
    { '<leader>cf', format, desc = '[F]ormat code' },
    { '<leader>cg', git.BranchName, desc = '[C]opy branch name' },
    { '<leader>cl', '<cmd>LspInfo<cr>', desc = 'Lsp Info' },
    { '<leader>ct', '<cmd>TSContextToggle<CR>', desc = '[T]reesitter Context Toggle' },
    { '<leader>be', neotreeUtil.BufferTree, desc = 'Buffer explorer' },
    { '<leader>e', neotreeUtil.ToggleNeotree, desc = 'N[E]otree' },
    { '<leader>gd', '<cmd>DiffviewOpen<CR>', desc = '[D]iff view' },
    { '<leader>gg', '<cmd>Neogit<CR>', desc = 'Neo[G]it' },
    { '<leader>m', '<cmd>Mason<cr>', desc = '[M]ason' },
  },
}
