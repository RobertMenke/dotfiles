-- snacks.nvim, currently used only for its dashboard (the prettiest and
-- best-maintained start screen; replaced mini.starter). Other snacks
-- modules stay disabled — but note snacks.picker is a plausible future
-- telescope replacement once plenary is archived.

-- Snacks centers each header line *individually*, so pad every line to a
-- common display width to keep the block's internal alignment intact.
local logo_lines = {
  '                                                    Remember that you  ',
  '                                                       will die      ',
  '       ████ ██████           █████      ██                     ',
  '      ███████████             █████                             ',
  '      █████████ ███████████████████ ███   ███████████   ',
  '     █████████  ███    █████████████ █████ ██████████████   ',
  '    █████████ ██████████ █████████ █████ █████ ████ █████   ',
  '  ███████████ ███    ███ █████████ █████ █████ ████ █████  ',
  ' ██████  █████████████████████ ████ █████ █████ ████ ██████ ',
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
        { section = 'keys', gap = 1, padding = 1 },
        -- '<n> plugins loaded in <x>ms' footer, like the old dashboards
        { section = 'startup' },
      },
    },
  },
}
