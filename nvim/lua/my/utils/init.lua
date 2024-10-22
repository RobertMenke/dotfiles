function CopyToClipboard(text)
  -- Use the `"+` register for the system clipboard
  vim.fn.setreg('+', text)
end
