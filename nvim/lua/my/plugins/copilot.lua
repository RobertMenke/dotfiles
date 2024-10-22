return {
  'zbirenbaum/copilot.lua',
  cmd = 'Copilot',
  event = { 'InsertEnter' },
  config = function()
    require('copilot').setup {
      suggestion = {
        auto_trigger = true,
        keymap = {
          accept = '<C-l>',
          next = '<C-n>',
          prev = '<C-p>',
          dismiss = '<C-d>',
        },
      },
    }
  end,
}
