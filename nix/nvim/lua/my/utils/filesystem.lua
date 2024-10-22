local Fs = {}

function Fs:CopyBufferName()
  vim.cmd "echo expand('%:p')"
  vim.cmd "let @+ = expand('%:p')"
  vim.cmd 'echo "Full path of " . expand(\'%:t\') . " was copied to system clipboard"'
end

return Fs
