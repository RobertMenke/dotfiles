-- okuuva/auto-save.nvim is the maintained fork of Pocco81/auto-save.nvim
-- (original abandoned ~2023). Drop-in replacement; the old custom
-- `condition` callback was a no-op ('&lua' is not a real option) so plain
-- defaults lose nothing.
return {
  'okuuva/auto-save.nvim',
  version = '^1',
  cmd = 'ASToggle',
  event = { 'InsertLeave', 'TextChanged' },
  opts = {},
}
