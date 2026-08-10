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
--   mini.starter     - start screen (replaced the loosely-maintained
--                      goolord/alpha-nvim)
local logo = table.concat({
  '                                                    Remember that you  ',
  '                                                       will die      ',
  '       ████ ██████           █████      ██                     ',
  '      ███████████             █████                             ',
  '      █████████ ███████████████████ ███   ███████████   ',
  '     █████████  ███    █████████████ █████ ██████████████   ',
  '    █████████ ██████████ █████████ █████ █████ ████ █████   ',
  '  ███████████ ███    ███ █████████ █████ █████ ████ █████  ',
  ' ██████  █████████████████████ ████ █████ █████ ████ ██████ ',
}, '\n')

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
        'ministarter',
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

    local starter = require 'mini.starter'
    starter.setup {
      header = logo,
      evaluate_single = true,
      items = {
        { name = 'New file', action = 'enew | startinsert', section = 'Actions' },
        { name = 'Find file', action = 'Telescope find_files', section = 'Actions' },
        { name = 'Find word', action = 'Telescope live_grep', section = 'Actions' },
        { name = 'Recent files', action = 'Telescope oldfiles', section = 'Actions' },
        { name = 'Config', action = 'edit $MYVIMRC', section = 'Actions' },
        { name = 'Mason', action = 'Mason', section = 'Actions' },
        { name = 'Lazy', action = 'Lazy', section = 'Actions' },
        { name = 'Quit', action = 'qa', section = 'Actions' },
      },
      footer = function()
        local ok, lazy = pcall(require, 'lazy')
        if not ok then
          return ''
        end
        local stats = lazy.stats()
        return string.format('󱐌 %d plugins loaded in %.2f ms', stats.count, stats.startuptime)
      end,
    }

    -- Startup time is only known after lazy finishes; refresh the footer.
    vim.api.nvim_create_autocmd('User', {
      pattern = 'VeryLazy',
      callback = function()
        if vim.bo.filetype == 'ministarter' then
          pcall(MiniStarter.refresh)
        end
      end,
    })
  end,
}
