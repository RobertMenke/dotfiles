-- IMPORTANT: rust-analyzer must be installed via `rustup component add rust-analyzer` for this plugin to work
return {
  'mrcjkb/rustaceanvim',
  version = '^4', -- Recommended
  ft = { 'rust' },
  opts = {
    server = {
      on_attach = function(_, bufnr)
        vim.keymap.set('n', '<leader>cR', function()
          vim.cmd.RustLsp 'codeAction'
        end, { desc = 'Code Action', buffer = bufnr })
        vim.keymap.set('n', '<leader>dr', function()
          vim.cmd.RustLsp 'debuggables'
        end, { desc = 'Rust Debuggables', buffer = bufnr })
        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
      end,
      default_settings = {
        -- rust-analyzer language server configuration
        ['rust-analyzer'] = {
          cargo = {
            allFeatures = true,
            loadOutDirsFromCheck = true,
            buildScripts = {
              enable = true,
            },
          },
          completions = {
            snippets = {
              enable = false
            }
          },
          -- Add clippy lints for Rust.
          checkOnSave = true,
        },
      },
    },
  },
  config = function(_, opts)
    vim.g.rustaceanvim = vim.tbl_deep_extend('keep', vim.g.rustaceanvim or {}, opts or {})
    if vim.fn.executable 'rust-analyzer' == 0 then
      error('**rust-analyzer** not found in PATH, please install it.\nhttps://rust-analyzer.github.io/', 1)
    end

    -- see :h rustaceanvim.mason
    -- vim.g.rustaceanvim = {
    --   server = {
    --     cmd = function()
    --       local mason_registry = require 'mason-registry'
    --       local ra_binary = mason_registry.is_installed 'rust-analyzer'
    --           -- This may need to be tweaked, depending on the operating system.
    --           and mason_registry.get_package('rust-analyzer'):get_install_path() .. '/rust-analyzer'
    --         or 'rust-analyzer'
    --       return { ra_binary } -- You can add args to the list, such as '--log-file'
    --     end,
    --   },
    -- }
  end,
}
