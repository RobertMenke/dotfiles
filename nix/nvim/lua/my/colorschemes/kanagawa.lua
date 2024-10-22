return {
  'rebelot/kanagawa.nvim',
  name = 'kanagawa',
  config = function()
    require('kanagawa').setup {
      transparent = true,
      colors = {
        theme = {
          all = {
            ui = {
              bg_gutter = 'none',
            },
          },
        },
      },
    }
    vim.api.nvim_command 'colorscheme kanagawa'
    vim.api.nvim_command 'colorscheme kanagawa-dragon'
    -- Telescope transparency
    vim.cmd 'highlight TelescopeBorder guibg=none'
    vim.cmd 'highlight TelescopeTitle guibg=none'
    -- Noice/Mini transparency
    vim.cmd 'highlight NoiceMini guibg=none'
    -- vim.cmd 'highlight NormalFloat guibg=none'
    -- Lualine transparency
    vim.cmd 'highlight lualine_c_normal guibg=none'
    vim.cmd 'highlight lualine_c_insert guibg=none'
    vim.cmd 'highlight lualine_c_visual guibg=none'
    vim.cmd 'highlight lualine_c_replace guibg=none'
    vim.cmd 'highlight lualine_c_command guibg=none'
    vim.cmd 'highlight lualine_c_inactive guibg=none'
  end,
}
