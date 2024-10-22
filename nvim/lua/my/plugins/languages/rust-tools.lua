return {
  'simrat39/rust-tools.nvim',
  config = function()
    local rust_tools = require 'rust-tools'

    rust_tools.setup {
      tools = {
        hover_actions = {
          auto_focus = true,
        },
        runnables = {
          use_telescope = true,
        },
        inlay_hints = {
          auto = false,
        },
      },
      server = {
        on_attach = function(_, bufnr)
          -- The rust-tools plugin loses some of the lunarvim key mappings and this function can be used to restore them on_attach
          local mappings = {
            normal_mode = 'n',
            insert_mode = 'i',
            visual_mode = 'v',
          }

          local buffer_mappings = {
            normal_mode = {
              ['K'] = { '<cmd>lua vim.lsp.buf.hover()<cr>', 'Show hover' },
              ['gd'] = { '<cmd>lua vim.lsp.buf.definition()<cr>', 'Goto Definition' },
              ['gD'] = { '<cmd>lua vim.lsp.buf.declaration()<cr>', 'Goto declaration' },
              ['gr'] = { '<cmd>lua vim.lsp.buf.references()<cr>', 'Goto references' },
              ['gI'] = { '<cmd>lua vim.lsp.buf.implementation()<cr>', 'Goto Implementation' },
              ['gs'] = { '<cmd>lua vim.lsp.buf.signature_help()<cr>', 'show signature help' },
              ['gl'] = {
                function()
                  vim.diagnostic.open_float { bufnr = 0, scope = 'line' }
                end,
                'Show line diagnostics',
              },
            },
            insert_mode = {},
            visual_mode = {},
          }

          for mode_name, mode_char in pairs(mappings) do
            for key, remap in pairs(buffer_mappings[mode_name]) do
              local opts = { buffer = bufnr, desc = remap[2], noremap = true, silent = true }
              vim.keymap.set(mode_char, key, remap[1], opts)
            end
          end
        end,
        before_init = function(initialize_params, config)
          -- Override clippy to run in its own directory to avoid clobbering caches
          -- but only if target-dir isn't already set in either the command or the extraArgs
          local checkOnSave = config.settings['rust-analyzer'].checkOnSave

          -- Lua apparently interprets `-` as a pattern and writing `%-` escapes it(!)
          local needle = '%-%-target%-dir'

          if string.find(checkOnSave.command, needle) then
            return
          end

          local extraArgs = checkOnSave.extraArgs
          for k, v in pairs(extraArgs) do
            if string.find(v, needle) then
              return
            end
          end

          local target_dir = config.root_dir .. '/target/ide-clippy'
          table.insert(extraArgs, '--target-dir=' .. target_dir)
        end,
        settings = {
          ['rust-analyzer'] = {
            rust = {
              analyzerTargetDirectory = true,
            },
            cargo = {
              allFeatures = true,
              -- target = "aarch64-linux-android"
              -- target = "x86_64-pc-windows-msvc"
            },
            checkOnSave = {
              allTargets = true,
              --
              command = 'clippy',
              extraArgs = {},
            },
            diagnostics = {
              disabled = { 'inactive-code' },
            },
            files = {
              -- Rust analyzer on mac causes high CPU load in fseventsd.
              -- We cut down on this significantly by ignoring directories
              -- that contain lots of non-rust files
              -- excludeDirs = filesToExclude,
              -- watcherExclude = filesToExclude,
            },
          },
        },
      },
    }
  end,
  ft = { 'rust', 'rs' },
}
