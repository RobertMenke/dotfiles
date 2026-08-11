-- Autocompletion via blink.cmp (successor to nvim-cmp, which is in
-- maintenance stasis — kickstart.nvim made the same switch). lsp / path /
-- buffer / snippet sources, signature help, and a Rust fuzzy matcher are
-- all built in, replacing nvim-cmp + cmp-nvim-lsp + cmp-path + cmp-buffer
-- + cmp_luasnip + lspkind (and LuaSnip, since we defined no custom
-- snippets).

-- blink wants bare icons; my.icons pads them with a trailing space for
-- nvim-cmp style menus.
local kind_icons = {}
for kind, icon in pairs(require('my.icons').kind) do
  kind_icons[kind] = (icon:gsub('%s+$', ''))
end

return {
  'saghen/blink.cmp',
  event = 'InsertEnter',
  -- Release tags ship a prebuilt fuzzy-matcher binary; without a version,
  -- building from source requires a nightly Rust toolchain.
  version = '1.*',
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    keymap = {
      -- 'default' preset: <C-y> accept, <C-n>/<C-p> select, <C-space> to
      -- open the menu / toggle docs, <C-e> hide — same muscle memory as the
      -- old nvim-cmp mappings.
      preset = 'default',
      ['<CR>'] = { 'accept', 'fallback' },
    },
    completion = {
      menu = {
        -- blink links its menu to `Pmenu`, and kanagawa gives Pmenu a blue
        -- (`ui.bg_visual`, #223249) that clashes with everything else here.
        -- nvim-cmp's `window.bordered()` used to render on NormalFloat, so
        -- point blink at the same float colors the docs/signature windows
        -- (and the rest of our floats) already use.
        winhighlight = 'Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None',
      },
      documentation = { auto_show = true, auto_show_delay_ms = 250 },
    },
    appearance = {
      kind_icons = kind_icons,
    },
    signature = { enabled = true },
    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
    },
    fuzzy = { implementation = 'prefer_rust_with_warning' },
  },
}
