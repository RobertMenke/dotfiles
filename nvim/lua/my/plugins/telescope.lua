-- NOTE: Plugins can specify dependencies.
--
-- The dependencies are proper plugin specifications as well - anything
-- you do for a plugin at the top level, you can do for a dependency.
--
-- Use the `dependencies` key to specify the dependencies of a particular plugin
-- Partially inspired from https://github.com/mrjones2014/dotfiles/blob/master/nvim/lua/my/configure/telescope.lua

return { -- Fuzzy Finder (files, lsp, etc)
  'nvim-telescope/telescope.nvim',
  event = 'VimEnter',
  branch = '0.1.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    { -- If encountering errors, see telescope-fzf-native README for install instructions
      'nvim-telescope/telescope-fzf-native.nvim',

      -- `build` is used to run some command when the plugin is installed/updated.
      -- This is only run then, not every time Neovim starts up.
      build = 'make',

      -- `cond` is a condition used to determine whether this plugin should be
      -- installed and loaded.
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
    { 'nvim-telescope/telescope-ui-select.nvim' },

    -- Useful for getting pretty icons, but requires special font.
    --  If you already have a Nerd Font, or terminal set up with fallback fonts
    --  you can enable this
    -- { 'nvim-tree/nvim-web-devicons' }
  },
  config = function()
    local actions = require 'telescope.actions'
    local smart_send_to_qflist = actions.smart_send_to_qflist + actions.open_qflist

    local function parse_prompt(prompt)
      local first_word, rest = prompt:match '^%s*@(%S+)%s*(.*)$'
      if first_word == nil then
        return { prompt = prompt, filetype = nil }
      end

      first_word = first_word:lower()
      if first_word == 'makefile' then
        return { prompt = rest, filetype = 'Makefile' }
      elseif first_word:match '^[tj]s$' then
        return { prompt = rest, filetype = { 'ts', 'tsx', 'js', 'jsx' } }
      elseif #first_word > 1 then
        return { prompt = rest, filetype = first_word }
      else
        return { prompt = prompt, filetype = nil }
      end
    end

    local function file_extension_filter(prompt)
      local parsed = parse_prompt(prompt)
      if parsed.filetype == nil then
        return { prompt = prompt }
      end

      local pattern = parsed.filetype
      if type(parsed.filetype) == 'table' then
        pattern = string.format('(%s)', table.concat(parsed.filetype --[[@as table]], '|'))
      end

      return {
        prompt = string.format('%s%s%s', parsed.prompt, tostring(pattern):lower() == 'makefile' and '/' or '.', pattern),
      }
    end
    -- Telescope is a fuzzy finder that comes with a lot of different things that
    -- it can fuzzy find! It's more than just a "file finder", it can search
    -- many different aspects of Neovim, your workspace, LSP, and more!
    --
    -- The easiest way to use telescope, is to start by doing something like:
    --  :Telescope help_tags
    --
    -- After running this command, a window will open up and you're able to
    -- type in the prompt window. You'll see a list of help_tags options and
    -- a corresponding preview of the help.
    --
    -- Two important keymaps to use while in telescope are:
    --  - Insert mode: <c-/>
    --  - Normal mode: ?
    --
    -- This opens a window that shows you all of the keymaps for the current
    -- telescope picker. This is really useful to discover what Telescope can
    -- do as well as how to actually do it!

    -- [[ Configure Telescope ]]
    -- See `:help telescope` and `:help telescope.setup()`
    require('telescope').setup {
      -- You can put your default mappings / updates / etc. in here
      --  All the info you're looking for is in `:help telescope.setup()`
      --
      -- defaults = {
      --   mappings = {
      --     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
      --   },
      -- },
      -- pickers = {}
      defaults = {
        vimgrep_arguments = {
          'rg',
          '--hidden',
          '--no-heading',
          '--with-filename',
          '--line-number',
          '--column',
          '--smart-case',
          '--ignore-file',
        },
        dynamic_preview_title = true,
        path_display = { "filename_first" },
        mappings = {
          i = {
            ['<C-q>'] = smart_send_to_qflist,
            ['<C-n>'] = actions.move_selection_next,
            ['<C-p>'] = actions.move_selection_previous,
          },

          n = {
            ['<C-q>'] = smart_send_to_qflist,
            ['<C-n>'] = actions.move_selection_next,
            ['<C-p>'] = actions.move_selection_previous,
            ['q'] = actions.close,
          },
        },
        pickers = {
          on_input_filter_cb = file_extension_filter,
          live_grep = {
            on_input_filter_cb = function(prompt)
              local parsed = parse_prompt(prompt)
              if parsed.filetype == nil then
                return {
                  prompt = parsed.prompt,
                  updated_finder = require('telescope.finders').new_job(function(new_prompt)
                    return vim.tbl_flatten {
                      require('telescope.config').values.vimgrep_arguments,
                      '--',
                      new_prompt,
                    }
                  end, require('telescope.make_entry').gen_from_vimgrep {}, nil, nil),
                }
              end

              local pattern
              if type(parsed.filetype) == 'table' then
                pattern = string.format('*.{%s}', table.concat(parsed.filetype --[[@as table]], ','))
              elseif
                (parsed.filetype --[[@as string]]):lower() == 'makefile'
              then
                pattern = '*Makefile'
              else
                pattern = string.format('*.%s', parsed.filetype)
              end

              return {
                prompt = parsed.prompt,
                updated_finder = require('telescope.finders').new_job(function(new_prompt)
                  return vim.tbl_flatten {
                    require('telescope.config').values.vimgrep_arguments,
                    '-g',
                    pattern,
                    '--',
                    new_prompt,
                  }
                end, require('telescope.make_entry').gen_from_vimgrep {}, nil, nil),
              }
            end,
          },
        },
      },
      extensions = {
        ['ui-select'] = {
          require('telescope.themes').get_dropdown(),
        },
      },
    }

    -- Enable telescope extensions, if they are installed
    pcall(require('telescope').load_extension, 'fzf')
    pcall(require('telescope').load_extension, 'ui-select')

    -- See `:help telescope.builtin`
    local builtin = require 'telescope.builtin'
    vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
    vim.keymap.set('n', '<leader>sH', builtin.highlights, { desc = '[S]earch [H]ighlights' })
    vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
    vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
    vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
    vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
    vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
    vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
    vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
    vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
    vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
    vim.keymap.set('n', '<leader>sG', builtin.git_branches, { desc = '[S]earch Git Branches' })

    -- Slightly advanced example of overriding default behavior and theme
    vim.keymap.set('n', '<leader>/', function()
      -- You can pass additional configuration to telescope to change theme, layout, etc.
      builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 10,
        previewer = false,
      })
    end, { desc = '[/] Fuzzily search in current buffer' })

    -- Also possible to pass additional configuration options.
    --  See `:help telescope.builtin.live_grep()` for information about particular keys
    vim.keymap.set('n', '<leader>s/', function()
      builtin.live_grep {
        grep_open_files = true,
        prompt_title = 'Live Grep in Open Files',
      }
    end, { desc = '[S]earch [/] in Open Files' })

    -- Shortcut for searching your neovim configuration files
    vim.keymap.set('n', '<leader>sn', function()
      builtin.find_files { cwd = vim.fn.stdpath 'config' }
    end, { desc = '[S]earch [N]eovim files' })

    -- Register noice with telescope and add a keybind for it
    require('telescope').load_extension 'noice'
    vim.keymap.set('n', '<leader>sm', '<cmd>Telescope noice<cr>', { desc = '[S]earch [M]essages' })
  end,
}
