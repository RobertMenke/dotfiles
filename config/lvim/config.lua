--[[
lvim is the global options object

Linters should be
filled in as strings with either
a global executable or a path to
an executable
]]
-- THESE ARE EXAMPLE CONFIGS FEEL FREE TO CHANGE TO WHATEVER YOU WANT
-- https://www.lunarvim.org/configuration/01-settings.html#example-options
vim.opt.relativenumber = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.termguicolors = true

-- general
lvim.log.level = "warn"
lvim.format_on_save = false
lvim.colorscheme = "onenord"
lvim.builtin.dap.active = true
lvim.builtin.gitsigns.opts = {
    signcolumn = true,
    linehl = false,
    numhl = true,
    current_line_blame = true,
    current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
        delay = 100,
        ignore_whitespace = false,
    }
}
vim.wo.fillchars = 'eob: '

-- keymappings [view all the defaults by pressing <leader>Lk]
lvim.leader = "space"
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"
lvim.keys.normal_mode["<C-n>"] = ":cn<CR>"
lvim.keys.normal_mode["<C-p>"] = ":cp<CR>"
-- Shorthand moving between splits
lvim.keys.normal_mode["<C-v>"] = "<C-w><C-v>"
lvim.keys.normal_mode["<C-l>"] = "<C-w><C-l>"
lvim.keys.normal_mode["<C-h>"] = "<C-w><C-h>"


-- Use which-key to add extra bindings with the leader-key prefix
-- lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }
lvim.builtin.which_key.mappings["t"] = {
    name = "Test",
    f = { "<cmd>TestFile<cr>", "File" },
    n = { "<cmd>TestNearest<cr>", "Nearest" },
    s = { "<cmd>TestSuite<cr>", "Suite" },
    l = { "<cmd>TestSuite<cr>", "Last" },
}

-- TODO: User Config for predefined plugins
-- After changing plugin config exit and reopen LunarVim, Run :PackerInstall :PackerCompile
-- lvim.builtin.alpha.active = true
lvim.builtin.notify.active = true
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.show_icons.git = 0

-- if you don't want all the parsers change this to a table of the ones you want
lvim.builtin.treesitter.ensure_installed = {
    "bash",
    "c",
    "javascript",
    "json",
    "lua",
    "python",
    "typescript",
    "tsx",
    "css",
    "rust",
    "java",
    "yaml",
}

-- Change Telescope navigation to use j and k for navigation and n and p for history in both input and normal mode.
-- we use protected-mode (pcall) just in case the plugin wasn't loaded yet.
local _, actions = pcall(require, "telescope.actions")
lvim.builtin.telescope.defaults.mappings = {
    --   -- for input mode
    i = {
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-n>"] = actions.cycle_history_next,
        ["<C-p>"] = actions.cycle_history_prev,
        ['<C-q>'] = actions.smart_add_to_qflist + actions.open_qflist,
    },
    --   -- for normal mode
    n = {
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
    },
}

-- generic LSP settings

-- ---@usage disable automatic installation of servers
-- lvim.lsp.automatic_servers_installation = true

-- ---@usage Select which servers should be configured manually. Requires `:LvimCacheRest` to take effect.
-- See the full default list `:lua print(vim.inspect(lvim.lsp.override))`
-- vim.list_extend(lvim.lsp.override, { "pyright" })

-- ---@usage setup a server -- see: https://www.lunarvim.org/languages/#overriding-the-default-configuration
-- local opts = {} -- check the lspconfig documentation for a list of all possible options
-- require("lvim.lsp.manager").setup("pylsp", opts)

-- -- you can set a custom on_attach function that will be used for all the language servers
-- -- See <https://github.com/neovim/nvim-lspconfig#keybindings-and-completion>
-- lvim.lsp.on_attach_callback = function(client, bufnr)
--   local function buf_set_option(...)
--     vim.api.nvim_buf_set_option(bufnr, ...)
--   end
--   --Enable completion triggered by <c-x><c-o>
--   buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
-- end

-- -- set a formatter, this will override the language server formatting capabilities (if it exists)
-- local formatters = require "lvim.lsp.null-ls.formatters"
-- formatters.setup {
--   { command = "black", filetypes = { "python" } },
--   { command = "isort", filetypes = { "python" } },
--   {
--     -- each formatter accepts a list of options identical to https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md#Configuration
--     command = "prettier",
--     ---@usage arguments to pass to the formatter
--     -- these cannot contain whitespaces, options such as `--line-width 80` become either `{'--line-width', '80'}` or `{'--line-width=80'}`
--     extra_args = { "--print-with", "100" },
--     ---@usage specify which filetypes to enable. By default a providers will attach to all the filetypes it supports.
--     filetypes = { "typescript", "typescriptreact" },
--   },
-- }

-- -- set additional linters
-- local linters = require "lvim.lsp.null-ls.linters"
-- linters.setup {
--   { command = "flake8", filetypes = { "python" } },
--   {
--     -- each linter accepts a list of options identical to https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md#Configuration
--     command = "shellcheck",
--     ---@usage arguments to pass to the formatter
--     -- these cannot contain whitespaces, options such as `--line-width 80` become either `{'--line-width', '80'}` or `{'--line-width=80'}`
--     extra_args = { "--severity", "warning" },
--   },
--   {
--     command = "codespell",
--     ---@usage specify which filetypes to enable. By default a providers will attach to all the filetypes it supports.
--     filetypes = { "javascript", "python" },
--   },
-- }

-- https://www.lunarvim.org/languages/rust.html#debugger
vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "rust_analyzer" })

-- Additional Plugins
lvim.plugins = {
    {
        "rktjmp/lush.nvim",
    },
    {
        'rmehri01/onenord.nvim',
        config = function()
            require("onenord").setup({
                -- disable = {
                --     background = true
                -- }
            })
        end,
    },
    {
        "Pocco81/AutoSave.nvim",
        config = function()
            require("autosave").setup({})
        end,
    },
    {
        "norcalli/nvim-colorizer.lua",
        config = function()
            require("colorizer").setup({ "*" }, {
                RGB = true, -- #RGB hex codes
                RRGGBB = true, -- #RRGGBB hex codes
                RRGGBBAA = true, -- #RRGGBBAA hex codes
                rgb_fn = true, -- CSS rgb() and rgba() functions
                hsl_fn = true, -- CSS hsl() and hsla() functions
                css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
                css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
            })
        end,
    },
    {
        "iamcco/markdown-preview.nvim",
        run = "cd app && npm install",
        ft = "markdown",
        config = function()
            vim.g.mkdp_auto_start = 1
        end,
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        event = "BufRead",
        setup = function()
            vim.g.indentLine_enabled = 1
            vim.g.indent_blankline_char = "▏"
            vim.g.indent_blankline_filetype_exclude = { "help", "terminal", "dashboard" }
            vim.g.indent_blankline_buftype_exclude = { "terminal" }
            vim.g.indent_blankline_show_trailing_blankline_indent = false
            vim.g.indent_blankline_show_first_indent_level = false
        end
    },
    {
        "simrat39/rust-tools.nvim",
        config = function()
            local lsp_installer_servers = require "nvim-lsp-installer.servers"
            local _, requested_server = lsp_installer_servers.get_server "rust_analyzer"
            local extension_path = vim.env.HOME .. '/.vscode/extensions/vadimcn.vscode-lldb-1.7.0/'
            local codelldb_path = extension_path .. 'adapter/codelldb'
            local liblldb_path = extension_path .. 'lldb/lib/liblldb.dylib'

            require("rust-tools").setup({
                dap = {
                    adapter = require('rust-tools.dap').get_codelldb_adapter(codelldb_path, liblldb_path)
                },
                tools = {
                    autoSetHints = true,
                    hover_with_actions = true,
                    runnables = {
                        use_telescope = true,
                    },
                },
                server = {
                    cmd_env = requested_server._default_options.cmd_env,
                    on_attach = require("lvim.lsp").common_on_attach,
                    on_init = require("lvim.lsp").common_on_init,
                },
            })
        end,
        ft = { "rust", "rs" },
    },
    {
        "kevinhwang91/nvim-bqf",
        event = { "BufRead", "BufNew" },
        config = function()
            require("bqf").setup({
                auto_enable = true,
                preview = {
                    win_height = 12,
                    win_vheight = 12,
                    delay_syntax = 80,
                    border_chars = { "┃", "┃", "━", "━", "┏", "┓", "┗", "┛", "█" },
                },
                func_map = {
                    vsplit = "",
                    ptogglemode = "z,",
                    stoggleup = "",
                },
                filter = {
                    fzf = {
                        action_for = { ["ctrl-s"] = "split" },
                        extra_opts = { "--bind", "ctrl-o:toggle-all", "--prompt", "> " },
                    },
                },
            })
        end,
    },
    {
        "vim-test/vim-test",
        cmd = { "TestNearest", "TestFile", "TestSuite", "TestLast", "TestVisit" },
        keys = { "<localleader>tf", "<localleader>tn", "<localleader>ts" },
        config = function()
            vim.cmd [[
          function! ToggleTermStrategy(cmd) abort
            call luaeval("require('toggleterm').exec(_A[1])", [a:cmd])
          endfunction
          let g:test#custom_strategies = {'toggleterm': function('ToggleTermStrategy')}
        ]]
            vim.g["test#strategy"] = "toggleterm"
        end,
    }
}

-- Autocommands (https://neovim.io/doc/user/autocmd.html)
-- lvim.autocommands.custom_groups = {
--   { "BufWinEnter", "*.lua", "setlocal ts=8 sw=8" },
-- }
