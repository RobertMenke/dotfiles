return {
  'xiyaowong/transparent.nvim',
  config = function()
    require('transparent').setup {
      extra_groups = { -- table/string: additional groups that should be cleared
        -- In particular, when you set it to 'all', that means all available groups

        -- example of akinsho/nvim-bufferline.lua
        'EndOfBuffer',
        -- Make telescope transparent
        'TelescopeNormal',
        'TelescopePromptBorder',
        'TelescopeResultsBorder',
        'TelescopePreviewBorder',
        'TelescopeBorder',
        'TelescopeTitle',
        -- Mason
        'MasonNormal',
        -- Make the which-key menu transparent
        'WhichKeyBorder',
        -- Making floating window borders transparent
        'FloatBorder',
        -- Inlay hints should be transparent
        'LspInlayHint',
        -- BQF
        'BqfPreviewFloat',

        'BufferLineTabClose',
        'BufferlineBufferSelected',
        'BufferLineFill',
        'BufferLineBackground',
        'BufferLineSeparator',
        'BufferLineIndicatorSelected',
        'NormalFloat', -- plugins which have float panel such as Lazy, Mason, LspInfo
        'NvimTreeNormal', -- NvimTree
        'NeoTreeSignColumn',
        'NeoTreeNormal',
        'NeoTreeNormalNC',
        'NeoTreeWinSeparator',
        'NeoTreeEndOfBuffer',
        'NeoTreeGitUnstaged',
        'NeoTreeBufferNumber',
        -- Noice
        'NoicePopup',
        'NoiceMini',
        'NoiceCmdlinePopup',
        'NoiceConfirm',
        'NoicePopupmenu',
        'NoiceVirtualText',
      },
      exclude_groups = {}, -- table: groups you don't want to clear
    }
  end,
}
