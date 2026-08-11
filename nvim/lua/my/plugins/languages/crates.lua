return {
  'saecki/crates.nvim',
  version = '^0.7',
  event = { 'BufRead Cargo.toml' },
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    require('crates').setup()
  end,
}
