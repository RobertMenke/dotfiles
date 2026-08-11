return { -- LSP Configuration & Plugins
  'neovim/nvim-lspconfig',
  dependencies = {
    -- Completion capabilities come from blink.cmp (see my.plugins.blink-cmp)
    'saghen/blink.cmp',
    -- Automatically install LSPs and related tools to stdpath for neovim
    'mason-org/mason.nvim',
    'mason-org/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    { 'folke/neoconf.nvim', cmd = 'Neoconf', config = false, dependencies = { 'nvim-lspconfig' } },
    -- opts = {
    --   servers = {
    --     sourcekit = {
    --       cmd = { '/Library/Developer/Toolchains/swift-latest.xctoolchain/usr/bin/sourcekit-lsp' },
    --     },
    --   },
    -- },
    -- Useful status updates for LSP.
    -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
    -- Currently using noice instead of fidget
    -- { 'j-hui/fidget.nvim', opts = {
    --   notification = {
    --     window = {
    --       winblend = 0,
    --     },
    --   },
    -- } },
  },
  config = function()
    -- Brief Aside: **What is LSP?**
    --
    -- LSP is an acronym you've probably heard, but might not understand what it is.
    --
    -- LSP stands for Language Server Protocol. It's a protocol that helps editors
    -- and language tooling communicate in a standardized fashion.
    --
    -- In general, you have a "server" which is some tool built to understand a particular
    -- language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc). These Language Servers
    -- (sometimes called LSP servers, but that's kind of like ATM Machine) are standalone
    -- processes that communicate with some "client" - in this case, Neovim!
    --
    -- LSP provides Neovim with features like:
    --  - Go to definition
    --  - Find references
    --  - Autocompletion
    --  - Symbol Search
    --  - and more!
    --
    -- Thus, Language Servers are external tools that must be installed separately from
    -- Neovim. This is where `mason` and related plugins come into play.
    --
    -- If you're wondering about lsp vs treesitter, you can check out the wonderfully
    -- and elegantly composed help section, `:help lsp-vs-treesitter`

    --  This function gets run when an LSP attaches to a particular buffer.
    --    That is to say, every time a new file is opened that is associated with
    --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
    --    function will be executed to configure the current buffer
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
      callback = function(event)
        -- NOTE: Remember that lua is a real programming language, and as such it is possible
        -- to define small helper and utility functions so you don't have to repeat yourself
        -- many times.
        --
        -- In this case, we create a function that lets us more easily define mappings specific
        -- for LSP related items. It sets the mode, buffer and description for us each time.
        local map = function(keys, func, desc)
          vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        -- Jump to the definition of the word under your cursor.
        --  This is where a variable was first declared, or where a function is defined, etc.
        --  To jump back, press <C-T>.
        map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

        -- Find references for the word under your cursor.
        map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

        -- Jump to the implementation of the word under your cursor.
        --  Useful when your language has ways of declaring types without an actual implementation.
        map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

        -- Jump to the type of the word under your cursor.
        --  Useful when you're not sure what type a variable is and you want to see
        --  the definition of its *type*, not where it was *defined*.
        map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')

        -- Fuzzy find all the symbols in your current document.
        --  Symbols are things like variables, functions, types, etc.
        map('<leader>ss', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')

        -- Fuzzy find all the symbols in your current workspace
        --  Similar to document symbols, except searches over your whole project.
        map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

        -- Execute a code action, usually your cursor needs to be on top of an error
        -- or a suggestion from your LSP for this to activate.
        map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

        -- Rename the variable under your cursor
        --  Most Language Servers support renaming across files, etc.
        map('<leader>cr', vim.lsp.buf.rename, '[R]ename')

        -- NOTE: `K` (hover) needs no mapping — it's a built-in LSP default
        -- since 0.10, as are grn (rename), gra (code action), grr
        -- (references) and gri (implementation). The maps above are kept
        -- for their telescope-flavored pickers and muscle memory.

        -- WARN: This is not Goto Definition, this is Goto Declaration.
        --  For example, in C this would take you to the header
        map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

        -- The following two autocommands are used to highlight references of the
        -- word under your cursor when your cursor rests there for a little while.
        --    See `:help CursorHold` for information about when this is executed
        --
        -- When you move your cursor, the highlights will be cleared (the second autocommand).
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client:supports_method 'textDocument/documentHighlight' then
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = event.buf,
            callback = vim.lsp.buf.document_highlight,
          })

          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = event.buf,
            callback = vim.lsp.buf.clear_references,
          })
        end
      end,
    })

    -- LSP servers and clients negotiate which protocol features they support.
    -- Neovim's defaults don't cover everything in the LSP spec; blink.cmp
    -- extends what the *client* can do. We build a shared capabilities
    -- table (blink merges in Neovim's defaults) and broadcast it to every
    -- enabled server via `vim.lsp.config('*', ...)` below.
    local capabilities = require('blink.cmp').get_lsp_capabilities()
    capabilities.textDocument.foldingRange = {
      dynamicRegistration = false,
      lineFoldingOnly = true,
    }

    -- Global defaults applied to every enabled LSP server. Per-server
    -- `vim.lsp.config(name, ...)` calls are merged on top.
    vim.lsp.config('*', {
      capabilities = capabilities,
    })

    -- Per-server configuration. Keys here must match server names recognized
    -- by nvim-lspconfig (which now ships configs via `vim.lsp.config` under
    -- the hood — see `:help lspconfig-all`). Each entry is merged on top of
    -- whatever nvim-lspconfig ships for that server.
    --
    -- Add new servers as:  servers.<name> = { settings = { ... } }
    -- For servers without custom settings, just add the name to
    -- `mason_servers` below.
    local servers = {
      lua_ls = {
        settings = {
          Lua = {
            runtime = { version = 'LuaJIT' },
            workspace = {
              checkThirdParty = false,
              -- Tell lua_ls where to find all the Lua files loaded for our
              -- Neovim configuration.
              library = {
                '${3rd}/luv/library',
                unpack(vim.api.nvim_get_runtime_file('', true)),
              },
              -- If lua_ls is really slow, swap the above for:
              -- library = { vim.env.VIMRUNTIME },
            },
            completion = {
              callSnippet = 'Replace',
            },
            -- Toggle to ignore lua_ls's noisy `missing-fields` warnings:
            -- diagnostics = { disable = { 'missing-fields' } },
          },
        },
      },

      -- TypeScript via vtsls (the community-recommended replacement for the
      -- unmaintained typescript-tools.nvim; also LazyVim's default).
      vtsls = {},

      -- Examples of servers you can uncomment and extend as needed. These
      -- only take effect once their binary is installed (typically via the
      -- `mason_servers` list below, which drives mason-tool-installer):
      -- clangd = {},
      -- gopls = {},
      -- pyright = {},
    }

    for name, opts in pairs(servers) do
      vim.lsp.config(name, opts)
    end

    -- Mason installs and manages external tools (LSPs, formatters, linters).
    -- `:Mason` for the UI; `g?` for help inside it.
    require('mason').setup {
      ui = {
        border = 'rounded',
      },
    }

    -- Servers we want Mason to install. `mason-lspconfig` (v2+) will then
    -- automatically call `vim.lsp.enable(<name>)` for each of them on
    -- startup (see `automatic_enable` below), so no manual `setup{}` call
    -- is required per server.
    local mason_servers = vim.tbl_keys(servers)

    require('mason-tool-installer').setup {
      ensure_installed = vim.list_extend(vim.deepcopy(mason_servers), {
        'stylua', -- Lua formatter
      }),
    }

    require('mason-lspconfig').setup {
      -- mason-tool-installer handles installs, so leave this empty.
      ensure_installed = {},
      automatic_installation = false,
      -- v2+: auto-calls `vim.lsp.enable()` for every mason-installed server.
      -- This replaces the removed v1 `handlers = { ... }` API.
      automatic_enable = true,
    }

    -- Servers not managed by mason (installed via nix, rustup, etc.) get
    -- their own module under `my.lsp.*` and are wired up explicitly here.
    -- They're responsible for their own `vim.lsp.config` + `vim.lsp.enable`
    -- calls, but inherit the global `*` capabilities set above.
    require('my.lsp.nixd').setup()

    -- Couldn't get swift/sourcekit working previously; left here as a
    -- reference for a future attempt. Uses the native API now:
    --
    --   vim.lsp.config('sourcekit', {
    --     cmd = { '/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/sourcekit-lsp' },
    --     filetypes = { 'swift', 'objc', 'objcpp' },
    --     root_markers = { 'Package.swift', 'compile_commands.json', '.git' },
    --   })
    --   vim.lsp.enable('sourcekit')
  end,
}
