-- Unifies split navigation across the nvim↔tmux boundary: <C-h/j/k/l> moves
-- between nvim windows until it hits the edge, then continues into the
-- neighbouring tmux pane.
--
-- The tmux half of the protocol is inlined in tmux.conf (the `is_vim` guard
-- plus four `bind -n` lines) rather than installed as a tmux plugin, so this
-- repo carries no tmux plugin manager. Nothing needs to stay in sync between
-- the two halves beyond that guard.
return {
  'christoomey/vim-tmux-navigator',
  init = function()
    -- Map the commands ourselves below so the descriptions reach which-key.
    -- The plugin's built-in mappings would otherwise shadow them silently.
    vim.g.tmux_navigator_no_mappings = 1
  end,
  cmd = {
    'TmuxNavigateLeft',
    'TmuxNavigateDown',
    'TmuxNavigateUp',
    'TmuxNavigateRight',
  },
  keys = {
    { '<C-h>', '<cmd>TmuxNavigateLeft<cr>', desc = 'Move focus to the left window/pane' },
    { '<C-j>', '<cmd>TmuxNavigateDown<cr>', desc = 'Move focus to the lower window/pane' },
    { '<C-k>', '<cmd>TmuxNavigateUp<cr>', desc = 'Move focus to the upper window/pane' },
    { '<C-l>', '<cmd>TmuxNavigateRight<cr>', desc = 'Move focus to the right window/pane' },
  },
}
