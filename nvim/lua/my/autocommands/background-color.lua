vim.api.nvim_create_augroup('nobg', { clear = true })
vim.api.nvim_create_autocmd({ 'ColorScheme' }, {
  desc = 'Make all backgrounds transparent',
  group = 'nobg',
  pattern = '*',
  callback = function()
    vim.api.nvim_set_hl(0, 'Normal', { bg = 'NONE', ctermbg = 'NONE' })
    vim.api.nvim_set_hl(0, 'NeoTreeSignColumn', { bg = 'NONE', ctermbg = 'NONE' })
    vim.api.nvim_set_hl(0, 'NeoTreeWinSeparator', { bg = 'NONE', ctermbg = 'NONE' })
    vim.api.nvim_set_hl(0, 'StatusLine', { bg = 'NONE', ctermbg = 'NONE' })
    vim.api.nvim_set_hl(0, 'StatusLineNC', { bg = 'NONE', ctermbg = 'NONE' })
    -- etc...
  end,
})
