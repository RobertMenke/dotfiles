-- Collection of various small independent plugins/modules. One mini.nvim
-- checkout supplies several modules that used to be separate plugins:
--
--   mini.ai          - better around/inside textobjects (va), ci', yinq...)
--   mini.pairs       - autopairs
--   mini.icons       - file icons; also mocks nvim-web-devicons for
--                      consumers that still require it (lualine, neo-tree,
--                      oil, telescope)
--   mini.indentscope - animated highlight of the current indent level
--                      (was a separate echasnovski/mini.indentscope install)
return {
  'echasnovski/mini.nvim',
  priority = 100, -- load before plugins that require the devicons mock
  config = function()
    -- Better Around/Inside textobjects
    --
    -- Examples:
    --  - va)  - [V]isually select [A]round [)]paren
    --  - yinq - [Y]ank [I]nside [N]ext [']quote
    --  - ci'  - [C]hange [I]nside [']quote
    require('mini.ai').setup { n_lines = 500 }

    require('mini.pairs').setup()

    local icons = require 'mini.icons'
    icons.setup()
    -- Serve `require('nvim-web-devicons')` from mini.icons so the real
    -- plugin is no longer needed.
    icons.mock_nvim_web_devicons()

    require('mini.indentscope').setup {
      symbol = '│',
      options = { try_as_border = true },
    }
    vim.api.nvim_create_autocmd('FileType', {
      desc = 'Disable indentscope in non-code buffers',
      pattern = {
        'help',
        'snacks_dashboard',
        'neo-tree',
        'Trouble',
        'trouble',
        'lazy',
        'mason',
        'notify',
        'toggleterm',
        'lazyterm',
      },
      callback = function()
        vim.b.miniindentscope_disable = true
      end,
    })
  end,
}
