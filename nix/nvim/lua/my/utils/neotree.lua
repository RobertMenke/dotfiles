local Neotree = {}

function Neotree.BufferTree()
  require('neo-tree.command').execute { source = 'buffers', toggle = true }
end

function Neotree.new()
  local self = setmetatable({}, Neotree)

  return self
end

function Neotree.IsNeoTreeOpen()
  -- Iterate over all buffers
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    -- Check if the buffer is loaded and visible
    if vim.api.nvim_buf_is_loaded(buf) then
      -- Get the buffer's filetype
      local filetype = vim.api.nvim_buf_get_option(buf, 'filetype')
      -- If the filetype is 'neo-tree', then NeoTree is open
      if filetype == 'neo-tree' then
        return true
      end
    end
  end
  -- If no 'neo-tree' buffer is found, NeoTree is closed
  return false
end

function Neotree.ToggleNeotree()
  if Neotree.IsNeoTreeOpen() then
    vim.cmd 'Neotree toggle'
  else
    vim.cmd 'Neotree source=filesystem reveal=true'
  end
end

return Neotree
