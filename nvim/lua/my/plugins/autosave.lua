return {
  'Pocco81/auto-save.nvim',
  config = function()
    require('auto-save').setup {
      condition = function(buf)
        local utils = require 'auto-save.utils.data'

        if utils.not_in(vim.fn.getbufvar(buf, '&lua'), {}) then
          return true
        end
      end,
    }
  end,
}
