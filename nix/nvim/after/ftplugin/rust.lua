local bufnr = vim.api.nvim_get_current_buf()
local map = function(keys, func, desc)
  vim.keymap.set('n', keys, func, { buffer = bufnr, desc = 'LSP: ' .. desc })
end

map(
  "<leader>ca",
  function ()
    vim.cmd.RustLsp('codeAction') -- supports rust-analyzer's grouping
    -- or vim.lsp.buf.codeAction() if you don't want grouping.
  end,
  "Rust Analyzer Code Action"
)
map(
  "gl",
  function()
    vim.cmd.RustLsp('renderDiagnostic')
  end,
  "Render Diagnostic"
)

map(
  "<leader>cD",
  function()
    vim.cmd.RustLsp('openDocs')
  end,
  "Open Rust Docs"
)

map(
  "<leader>cC",
  function()
    vim.cmd.RustLsp { 'crateGraph', '[backend]', '[output]' }
  end,
  "View Crate Graph"
)

map(
  "<leader>cm",
  function()
    vim.cmd.RustLsp { 'view', 'mir' }
  end,
  "View MIR Representation"
)

map(
  "<leader>ch",
  function()
    vim.cmd.RustLsp { 'view', 'hir' }
  end,
  "View HIR Representation"
)

map(
  "<leader>cC",
  function()
    vim.cmd.RustLsp('openCargo')
  end,
  "Open Cargo.toml"
)

map(
  "<leader>ce",
  function()
    vim.cmd.RustLsp('explainError')
  end,
  "Explain rust error code"
)

map(
  "<leader>cM",
  function()
    vim.cmd.RustLsp('expandMacro')
  end,
  "Expand macro recursively"
)

map(
  "<leader>cp",
  function()
    vim.cmd.RustLsp('parentModule')
  end,
  "Go to parent module"
)

map(
  "gs",
  function()
    vim.cmd.RustLsp('workspaceSymbol')
  end,
  "Go to parent module"
)
