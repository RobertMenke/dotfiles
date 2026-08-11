-- snacks.nvim, currently used only for its dashboard (the prettiest and
-- best-maintained start screen; replaced mini.starter). Other snacks
-- modules stay disabled — but note snacks.picker is a plausible future
-- telescope replacement once plenary is archived.

-- ANSI-Shadow figlet "NEOVIM". All lines are equal display width, and the
-- padding loop below keeps them that way: snacks centers each header line
-- *individually*, so unequal widths would shear the block.
local logo_lines = {
  '███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗',
  '████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║',
  '██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║',
  '██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║',
  '██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║',
  '╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝',
}
local width = 0
for _, line in ipairs(logo_lines) do
  width = math.max(width, vim.fn.strdisplaywidth(line))
end
for i, line in ipairs(logo_lines) do
  logo_lines[i] = line .. string.rep(' ', width - vim.fn.strdisplaywidth(line))
end
local logo = table.concat(logo_lines, '\n')

return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    dashboard = {
      enabled = true,
      preset = {
        header = logo,
        -- stylua: ignore
        keys = {
          { icon = ' ', key = 'e', desc = 'New File', action = ':ene | startinsert' },
          { icon = ' ', key = 'f', desc = 'Find File', action = ':Telescope find_files' },
          { icon = '󰱼 ', key = 'g', desc = 'Find Word', action = ':Telescope live_grep' },
          { icon = ' ', key = 'r', desc = 'Recent Files', action = ':Telescope oldfiles' },
          { icon = ' ', key = 'c', desc = 'Config', action = ':e $MYVIMRC' },
          { icon = '󱌣 ', key = 'm', desc = 'Mason', action = ':Mason' },
          { icon = '󰒲 ', key = 'l', desc = 'Lazy', action = ':Lazy' },
          { icon = ' ', key = 'q', desc = 'Quit', action = ':qa' },
        },
      },
      sections = {
        { section = 'header' },
        {
          text = { { 'Remember that you will die', hl = 'SnacksDashboardMemento' } },
          align = 'center',
          padding = 1,
        },
        { section = 'keys', gap = 1, padding = 1 },
        -- '<n> plugins loaded in <x>ms' footer, like the old dashboards
        { section = 'startup' },
      },
    },
  },
  config = function(_, opts)
    require('snacks').setup(opts)

    -- Tie the dashboard to the kanagawa dragon palette (same source as the
    -- lualine theme). Re-applied on ColorScheme so :colorscheme reloads
    -- don't wipe it.
    local function dashboard_highlights()
      local ok, kanagawa = pcall(require, 'kanagawa.colors')
      if not ok then
        return
      end
      local theme = kanagawa.setup({ theme = 'dragon' }).theme
      vim.api.nvim_set_hl(0, 'SnacksDashboardHeader', { fg = theme.syn.fun })
      vim.api.nvim_set_hl(0, 'SnacksDashboardMemento', { fg = theme.syn.comment, italic = true })
    end
    dashboard_highlights()
    vim.api.nvim_create_autocmd('ColorScheme', {
      group = vim.api.nvim_create_augroup('my-dashboard-hl', { clear = true }),
      callback = dashboard_highlights,
    })
  end,
}
