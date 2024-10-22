return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons', 'nvim-lua/lsp-status.nvim', 'rebelot/kanagawa.nvim' },
  config = function()
    local kcolors = require('kanagawa.colors').setup { theme = 'dragon' }
    local theme = kcolors.theme

    local bubbles_theme = {
      normal = {
        a = { bg = theme.syn.fun, fg = theme.ui.bg_m3 },
        b = { bg = theme.diff.change, fg = theme.syn.fun },
        c = { fg = theme.ui.fg },
      },

      insert = {
        a = { bg = theme.diag.ok, fg = theme.ui.bg },
        b = { bg = theme.ui.bg, fg = theme.diag.ok },
      },
      visual = { a = { bg = theme.syn.keyword, fg = theme.ui.bg }, b = { bg = theme.ui.bg, fg = theme.syn.keyword } },
      replace = { a = { bg = theme.syn.constant, fg = theme.ui.bg }, b = { bg = theme.ui.bg, fg = theme.syn.constant } },

      inactive = {
        a = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
        b = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim, gui = 'bold' },
        c = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
      },
    }

    require('lualine').setup {
      options = {
        theme = bubbles_theme,
        component_separators = '',
        section_separators = '',
        -- Alacritty has a bug rendering these fonts, womp womp
        -- section_separators = { left = '', right = '' },
      },
      sections = {
        lualine_a = {
          {
            'mode',
            -- separator = { left = '' } --[[ , right_padding = 2 ]],
          },
        },
        lualine_b = { { 'filename', path = 1 }, 'branch' },
        lualine_c = {
          '%=', --[[ add your center compoentnts here in place of this comment ]]
        },
        lualine_x = {},
        lualine_y = { 'filetype', "require'lsp-status'.status()" },
        lualine_z = {
          {
            'location',
            -- separator = { right = '' } --[[ , left_padding = 2 ]],
          },
        },
      },
      inactive_sections = {
        lualine_a = { 'filename' },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = { 'location' },
      },
      tabline = {},
      extensions = {},
    }
  end,
}
