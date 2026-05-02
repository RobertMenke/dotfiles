return { -- Autoformat
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  opts = {
    notify_on_error = false,
    formatters_by_ft = {
      lua = { 'stylua' },
      -- Conform can also run multiple formatters sequentially:
      --   python = { 'isort', 'black' },
      -- Or use a sub-list to run *until* a formatter is found.
      javascript = { 'prettier' },
      typescript = { 'prettier' },
      typescriptreact = { 'prettier' },
      css = { 'prettier' },
      html = { 'prettier' },
      json = { 'prettier' },
      graphql = { 'prettier' },
    },
    -- Format on save. Returning nil disables it for that buffer; here we
    -- skip filetypes whose LSP-only formatting we prefer to leave alone.
    format_on_save = function(bufnr)
      local ignore = { c = true, cpp = true }
      if ignore[vim.bo[bufnr].filetype] then
        return
      end
      return { timeout_ms = 500, lsp_format = 'fallback' }
    end,
  },
}
