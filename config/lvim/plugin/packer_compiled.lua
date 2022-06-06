-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

  local time
  local profile_info
  local should_profile = false
  if should_profile then
    local hrtime = vim.loop.hrtime
    profile_info = {}
    time = function(chunk, start)
      if start then
        profile_info[chunk] = hrtime()
      else
        profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
      end
    end
  else
    time = function(chunk, start) end
  end
  
local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end

  _G._packer = _G._packer or {}
  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/Users/rbmenke/.cache/lvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?.lua;/Users/rbmenke/.cache/lvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?/init.lua;/Users/rbmenke/.cache/lvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?.lua;/Users/rbmenke/.cache/lvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/Users/rbmenke/.cache/lvim/packer_hererocks/2.1.0-beta3/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s), name, _G.packer_plugins[name])
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  ["AutoSave.nvim"] = {
    config = { "\27LJ\2\nO\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\1\19debounce_delay\3Ù\3\nsetup\rautosave\frequire\0" },
    loaded = true,
    path = "/Users/rbmenke/.local/share/lunarvim/site/pack/packer/start/AutoSave.nvim",
    url = "https://github.com/Pocco81/AutoSave.nvim"
  },
  ["Comment.nvim"] = {
    after_files = { "/Users/rbmenke/.local/share/lunarvim/site/pack/packer/opt/Comment.nvim/after/plugin/Comment.lua" },
    config = { "\27LJ\2\n?\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\22lvim.core.comment\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/rbmenke/.local/share/lunarvim/site/pack/packer/opt/Comment.nvim",
    url = "https://github.com/numToStr/Comment.nvim"
  },
  ["FixCursorHold.nvim"] = {
    loaded = true,
    path = "/Users/rbmenke/.local/share/lunarvim/site/pack/packer/start/FixCursorHold.nvim",
    url = "https://github.com/antoinemadec/FixCursorHold.nvim"
  },
  LuaSnip = {
    config = { "\27LJ\2\n§\3\0\0\n\0\18\2-6\0\0\0'\2\1\0B\0\2\0024\1\3\0009\2\2\0006\4\3\0B\4\1\2'\5\4\0'\6\5\0'\a\6\0'\b\a\0'\t\b\0B\2\a\0?\2\0\0009\2\2\0006\4\t\0B\4\1\2'\5\n\0B\2\3\0029\3\v\0\18\5\2\0B\3\2\2\15\0\3\0X\4\3Ä\21\3\1\0\22\3\1\3<\2\3\0016\3\0\0'\5\f\0B\3\2\0029\3\r\3B\3\1\0016\3\0\0'\5\14\0B\3\2\0029\3\r\0035\5\15\0=\1\16\5B\3\2\0016\3\0\0'\5\17\0B\3\2\0029\3\r\3B\3\1\1K\0\1\0\"luasnip.loaders.from_snipmate\npaths\1\0\0 luasnip.loaders.from_vscode\14lazy_load\29luasnip.loaders.from_lua\17is_directory\rsnippets\19get_config_dir\22friendly-snippets\nstart\vpacker\tpack\tsite\20get_runtime_dir\15join_paths\15lvim.utils\frequire\3ÄÄ¿ô\4\2\0" },
    loaded = true,
    path = "/Users/rbmenke/.local/share/lunarvim/site/pack/packer/start/LuaSnip",
    url = "https://github.com/L3MON4D3/LuaSnip"
  },
  ["alpha-nvim"] = {
    config = { "\27LJ\2\n=\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\20lvim.core.alpha\frequire\0" },
    loaded = true,
    path = "/Users/rbmenke/.local/share/lunarvim/site/pack/packer/start/alpha-nvim",
    url = "https://github.com/goolord/alpha-nvim"
  },
  ["bufferline.nvim"] = {
    config = { "\27LJ\2\nB\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\25lvim.core.bufferline\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/rbmenke/.local/share/lunarvim/site/pack/packer/opt/bufferline.nvim",
    url = "https://github.com/akinsho/bufferline.nvim"
  },
  ["cmp-buffer"] = {
    loaded = true,
    path = "/Users/rbmenke/.local/share/lunarvim/site/pack/packer/start/cmp-buffer",
    url = "https://github.com/hrsh7th/cmp-buffer"
  },
  ["cmp-nvim-lsp"] = {
    loaded = true,
    path = "/Users/rbmenke/.local/share/lunarvim/site/pack/packer/start/cmp-nvim-lsp",
    url = "https://github.com/hrsh7th/cmp-nvim-lsp"
  },
  ["cmp-path"] = {
    loaded = true,
    path = "/Users/rbmenke/.local/share/lunarvim/site/pack/packer/start/cmp-path",
    url = "https://github.com/hrsh7th/cmp-path"
  },
  cmp_luasnip = {
    loaded = true,
    path = "/Users/rbmenke/.local/share/lunarvim/site/pack/packer/start/cmp_luasnip",
    url = "https://github.com/saadparwaiz1/cmp_luasnip"
  },
  ["dap-buddy.nvim"] = {
    loaded = true,
    path = "/Users/rbmenke/.local/share/lunarvim/site/pack/packer/start/dap-buddy.nvim",
    url = "https://github.com/Pocco81/dap-buddy.nvim"
  },
  ["friendly-snippets"] = {
    loaded = true,
    path = "/Users/rbmenke/.local/share/lunarvim/site/pack/packer/start/friendly-snippets",
    url = "https://github.com/rafamadriz/friendly-snippets"
  },
  ["gitsigns.nvim"] = {
    config = { "\27LJ\2\n@\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\23lvim.core.gitsigns\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/rbmenke/.local/share/lunarvim/site/pack/packer/opt/gitsigns.nvim",
    url = "https://github.com/lewis6991/gitsigns.nvim"
  },
  ["indent-blankline.nvim"] = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/rbmenke/.local/share/lunarvim/site/pack/packer/opt/indent-blankline.nvim",
    url = "https://github.com/lukas-reineke/indent-blankline.nvim"
  },
  ["lua-dev.nvim"] = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/rbmenke/.local/share/lunarvim/site/pack/packer/opt/lua-dev.nvim",
    url = "https://github.com/max397574/lua-dev.nvim"
  },
  ["lualine.nvim"] = {
    config = { "\27LJ\2\n?\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\22lvim.core.lualine\frequire\0" },
    loaded = true,
    path = "/Users/rbmenke/.local/share/lunarvim/site/pack/packer/start/lualine.nvim",
    url = "https://github.com/nvim-lualine/lualine.nvim"
  },
  ["lush.nvim"] = {
    loaded = true,
    path = "/Users/rbmenke/.local/share/lunarvim/site/pack/packer/start/lush.nvim",
    url = "https://github.com/rktjmp/lush.nvim"
  },
  ["markdown-preview.nvim"] = {
    config = { "\27LJ\2\n1\0\0\2\0\3\0\0056\0\0\0009\0\1\0)\1\1\0=\1\2\0K\0\1\0\20mkdp_auto_start\6g\bvim\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/rbmenke/.local/share/lunarvim/site/pack/packer/opt/markdown-preview.nvim",
    url = "https://github.com/iamcco/markdown-preview.nvim"
  },
  ["nlsp-settings.nvim"] = {
    loaded = true,
    path = "/Users/rbmenke/.local/share/lunarvim/site/pack/packer/start/nlsp-settings.nvim",
    url = "https://github.com/tamago324/nlsp-settings.nvim"
  },
  ["null-ls.nvim"] = {
    loaded = true,
    path = "/Users/rbmenke/.local/share/lunarvim/site/pack/packer/start/null-ls.nvim",
    url = "https://github.com/jose-elias-alvarez/null-ls.nvim"
  },
  ["nvim-autopairs"] = {
    config = { "\27LJ\2\nA\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\24lvim.core.autopairs\frequire\0" },
    loaded = true,
    path = "/Users/rbmenke/.local/share/lunarvim/site/pack/packer/start/nvim-autopairs",
    url = "https://github.com/windwp/nvim-autopairs"
  },
  ["nvim-bqf"] = {
    config = { "\27LJ\2\nı\2\0\0\6\0\18\0\0216\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\4\0005\4\5\0=\4\6\3=\3\a\0025\3\b\0=\3\t\0025\3\15\0005\4\v\0005\5\n\0=\5\f\0045\5\r\0=\5\14\4=\4\16\3=\3\17\2B\0\2\1K\0\1\0\vfilter\bfzf\1\0\0\15extra_opts\1\5\0\0\v--bind\22ctrl-o:toggle-all\r--prompt\a> \15action_for\1\0\0\1\0\1\vctrl-s\nsplit\rfunc_map\1\0\3\vvsplit\5\14stoggleup\5\16ptogglemode\az,\fpreview\17border_chars\1\n\0\0\b‚îÉ\b‚îÉ\b‚îÅ\b‚îÅ\b‚îè\b‚îì\b‚îó\b‚îõ\b‚ñà\1\0\3\17delay_syntax\3P\16win_vheight\3\f\15win_height\3\f\1\0\1\16auto_enable\2\nsetup\bbqf\frequire\0" },
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/Users/rbmenke/.local/share/lunarvim/site/pack/packer/opt/nvim-bqf",
    url = "https://github.com/kevinhwang91/nvim-bqf"
  },
  ["nvim-cmp"] = {
    config = { "\27LJ\2\n`\0\0\3\0\6\0\v6\0\0\0009\0\1\0009\0\2\0\15\0\0\0X\1\5Ä6\0\3\0'\2\4\0B\0\2\0029\0\5\0B\0\1\1K\0\1\0\nsetup\18lvim.core.cmp\frequire\bcmp\fbuiltin\tlvim\0" },
    loaded = true,
    path = "/Users/rbmenke/.local/share/lunarvim/site/pack/packer/start/nvim-cmp",
    url = "https://github.com/hrsh7th/nvim-cmp"
  },
  ["nvim-colorizer.lua"] = {
    config = { "\27LJ\2\n|\0\0\4\0\5\0\b6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\4\0B\0\3\1K\0\1\0\1\0\a\vcss_fn\2\vhsl_fn\2\vrgb_fn\2\rRRGGBBAA\2\vRRGGBB\2\bRGB\2\bcss\2\1\2\0\0\6*\nsetup\14colorizer\frequire\0" },
    loaded = true,
    path = "/Users/rbmenke/.local/share/lunarvim/site/pack/packer/start/nvim-colorizer.lua",
    url = "https://github.com/norcalli/nvim-colorizer.lua"
  },
  ["nvim-dap"] = {
    config = { "\27LJ\2\n;\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\18lvim.core.dap\frequire\0" },
    loaded = true,
    path = "/Users/rbmenke/.local/share/lunarvim/site/pack/packer/start/nvim-dap",
    url = "https://github.com/mfussenegger/nvim-dap"
  },
  ["nvim-lsp-installer"] = {
    loaded = true,
    path = "/Users/rbmenke/.local/share/lunarvim/site/pack/packer/start/nvim-lsp-installer",
    url = "https://github.com/williamboman/nvim-lsp-installer"
  },
  ["nvim-lspconfig"] = {
    loaded = true,
    path = "/Users/rbmenke/.local/share/lunarvim/site/pack/packer/start/nvim-lspconfig",
    url = "https://github.com/neovim/nvim-lspconfig"
  },
  ["nvim-notify"] = {
    config = { "\27LJ\2\n>\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\21lvim.core.notify\frequire\0" },
    loaded = true,
    path = "/Users/rbmenke/.local/share/lunarvim/site/pack/packer/start/nvim-notify",
    url = "https://github.com/rcarriga/nvim-notify"
  },
  ["nvim-tree.lua"] = {
    config = { "\27LJ\2\n@\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\23lvim.core.nvimtree\frequire\0" },
    loaded = true,
    path = "/Users/rbmenke/.local/share/lunarvim/site/pack/packer/start/nvim-tree.lua",
    url = "https://github.com/kyazdani42/nvim-tree.lua"
  },
  ["nvim-treesitter"] = {
    config = { "\27LJ\2\nB\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\25lvim.core.treesitter\frequire\0" },
    loaded = true,
    path = "/Users/rbmenke/.local/share/lunarvim/site/pack/packer/start/nvim-treesitter",
    url = "https://github.com/nvim-treesitter/nvim-treesitter"
  },
  ["nvim-ts-context-commentstring"] = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/rbmenke/.local/share/lunarvim/site/pack/packer/opt/nvim-ts-context-commentstring",
    url = "https://github.com/JoosepAlviste/nvim-ts-context-commentstring"
  },
  ["nvim-web-devicons"] = {
    loaded = true,
    path = "/Users/rbmenke/.local/share/lunarvim/site/pack/packer/start/nvim-web-devicons",
    url = "https://github.com/kyazdani42/nvim-web-devicons"
  },
  ["onenord.nvim"] = {
    config = { "\27LJ\2\n9\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\fonenord\frequire\0" },
    loaded = true,
    path = "/Users/rbmenke/.local/share/lunarvim/site/pack/packer/start/onenord.nvim",
    url = "https://github.com/rmehri01/onenord.nvim"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/Users/rbmenke/.local/share/lunarvim/site/pack/packer/start/packer.nvim",
    url = "https://github.com/wbthomason/packer.nvim"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/Users/rbmenke/.local/share/lunarvim/site/pack/packer/start/plenary.nvim",
    url = "https://github.com/nvim-lua/plenary.nvim"
  },
  ["popup.nvim"] = {
    loaded = true,
    path = "/Users/rbmenke/.local/share/lunarvim/site/pack/packer/start/popup.nvim",
    url = "https://github.com/nvim-lua/popup.nvim"
  },
  ["project.nvim"] = {
    config = { "\27LJ\2\n?\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\22lvim.core.project\frequire\0" },
    loaded = true,
    path = "/Users/rbmenke/.local/share/lunarvim/site/pack/packer/start/project.nvim",
    url = "https://github.com/ahmedkhalf/project.nvim"
  },
  ["rust-tools.nvim"] = {
    config = { "\27LJ\2\nÁ\4\0\0\14\0\31\00056\0\0\0'\2\1\0B\0\2\0029\1\2\0'\3\3\0B\1\2\0036\3\4\0009\3\5\0039\3\6\3'\4\a\0&\3\4\3\18\4\3\0'\5\b\0&\4\5\4\18\5\3\0'\6\t\0&\5\6\0056\6\0\0'\b\n\0B\6\2\0029\6\v\0065\b\16\0005\t\14\0006\n\0\0'\f\f\0B\n\2\0029\n\r\n\18\f\4\0\18\r\5\0B\n\3\2=\n\15\t=\t\17\b5\t\18\0005\n\19\0=\n\20\t=\t\21\b5\t\24\0009\n\22\0029\n\23\n=\n\23\t6\n\0\0'\f\25\0B\n\2\0029\n\26\n=\n\27\t6\n\0\0'\f\25\0B\n\2\0029\n\28\n=\n\29\t=\t\30\bB\6\2\1K\0\1\0\vserver\fon_init\19common_on_init\14on_attach\21common_on_attach\rlvim.lsp\1\0\0\fcmd_env\21_default_options\ntools\14runnables\1\0\1\18use_telescope\2\1\0\2\23hover_with_actions\2\17autoSetHints\2\bdap\1\0\0\fadapter\1\0\0\25get_codelldb_adapter\19rust-tools.dap\nsetup\15rust-tools\27lldb/lib/liblldb.dylib\21adapter/codelldb3/.vscode/extensions/vadimcn.vscode-lldb-1.7.0/\tHOME\benv\bvim\18rust_analyzer\15get_server\31nvim-lsp-installer.servers\frequire\0" },
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/Users/rbmenke/.local/share/lunarvim/site/pack/packer/opt/rust-tools.nvim",
    url = "https://github.com/simrat39/rust-tools.nvim"
  },
  ["schemastore.nvim"] = {
    loaded = true,
    path = "/Users/rbmenke/.local/share/lunarvim/site/pack/packer/start/schemastore.nvim",
    url = "https://github.com/b0o/schemastore.nvim"
  },
  ["structlog.nvim"] = {
    loaded = true,
    path = "/Users/rbmenke/.local/share/lunarvim/site/pack/packer/start/structlog.nvim",
    url = "https://github.com/Tastyep/structlog.nvim"
  },
  ["telescope-fzf-native.nvim"] = {
    loaded = true,
    path = "/Users/rbmenke/.local/share/lunarvim/site/pack/packer/start/telescope-fzf-native.nvim",
    url = "https://github.com/nvim-telescope/telescope-fzf-native.nvim"
  },
  ["telescope.nvim"] = {
    config = { "\27LJ\2\nA\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\24lvim.core.telescope\frequire\0" },
    loaded = true,
    path = "/Users/rbmenke/.local/share/lunarvim/site/pack/packer/start/telescope.nvim",
    url = "https://github.com/nvim-telescope/telescope.nvim"
  },
  ["toggleterm.nvim"] = {
    config = { "\27LJ\2\n@\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\23lvim.core.terminal\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/rbmenke/.local/share/lunarvim/site/pack/packer/opt/toggleterm.nvim",
    url = "https://github.com/akinsho/toggleterm.nvim"
  },
  ["vim-test"] = {
    commands = { "TestNearest", "TestFile", "TestSuite", "TestLast", "TestVisit" },
    config = { "\27LJ\2\nø\2\0\0\3\0\6\0\t6\0\0\0009\0\1\0'\2\2\0B\0\2\0016\0\0\0009\0\3\0'\1\5\0=\1\4\0K\0\1\0\15toggleterm\18test#strategy\6gÙ\1          function! ToggleTermStrategy(cmd) abort\n            call luaeval(\"require('toggleterm').exec(_A[1])\", [a:cmd])\n          endfunction\n          let g:test#custom_strategies = {'toggleterm': function('ToggleTermStrategy')}\n        \bcmd\bvim\0" },
    keys = { { "", "<localleader>tf" }, { "", "<localleader>tn" }, { "", "<localleader>ts" } },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/rbmenke/.local/share/lunarvim/site/pack/packer/opt/vim-test",
    url = "https://github.com/vim-test/vim-test"
  },
  ["which-key.nvim"] = {
    config = { "\27LJ\2\nA\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\24lvim.core.which-key\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/rbmenke/.local/share/lunarvim/site/pack/packer/opt/which-key.nvim",
    url = "https://github.com/max397574/which-key.nvim"
  }
}

time([[Defining packer_plugins]], false)
local module_lazy_loads = {
  ["^lua%-dev"] = "lua-dev.nvim"
}
local lazy_load_called = {['packer.load'] = true}
local function lazy_load_module(module_name)
  local to_load = {}
  if lazy_load_called[module_name] then return nil end
  lazy_load_called[module_name] = true
  for module_pat, plugin_name in pairs(module_lazy_loads) do
    if not _G.packer_plugins[plugin_name].loaded and string.match(module_name, module_pat) then
      to_load[#to_load + 1] = plugin_name
    end
  end

  if #to_load > 0 then
    require('packer.load')(to_load, {module = module_name}, _G.packer_plugins)
    local loaded_mod = package.loaded[module_name]
    if loaded_mod then
      return function(modname) return loaded_mod end
    end
  end
end

if not vim.g.packer_custom_loader_enabled then
  table.insert(package.loaders, 1, lazy_load_module)
  vim.g.packer_custom_loader_enabled = true
end

-- Setup for: indent-blankline.nvim
time([[Setup for indent-blankline.nvim]], true)
try_loadstring("\27LJ\2\n„\2\0\0\2\0\v\0\0256\0\0\0009\0\1\0)\1\1\0=\1\2\0006\0\0\0009\0\1\0'\1\4\0=\1\3\0006\0\0\0009\0\1\0005\1\6\0=\1\5\0006\0\0\0009\0\1\0005\1\b\0=\1\a\0006\0\0\0009\0\1\0+\1\1\0=\1\t\0006\0\0\0009\0\1\0+\1\1\0=\1\n\0K\0\1\0-indent_blankline_show_first_indent_level4indent_blankline_show_trailing_blankline_indent\1\2\0\0\rterminal%indent_blankline_buftype_exclude\1\4\0\0\thelp\rterminal\14dashboard&indent_blankline_filetype_exclude\b‚ñè\26indent_blankline_char\23indentLine_enabled\6g\bvim\0", "setup", "indent-blankline.nvim")
time([[Setup for indent-blankline.nvim]], false)
-- Config for: project.nvim
time([[Config for project.nvim]], true)
try_loadstring("\27LJ\2\n?\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\22lvim.core.project\frequire\0", "config", "project.nvim")
time([[Config for project.nvim]], false)
-- Config for: telescope.nvim
time([[Config for telescope.nvim]], true)
try_loadstring("\27LJ\2\nA\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\24lvim.core.telescope\frequire\0", "config", "telescope.nvim")
time([[Config for telescope.nvim]], false)
-- Config for: AutoSave.nvim
time([[Config for AutoSave.nvim]], true)
try_loadstring("\27LJ\2\nO\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\1\19debounce_delay\3Ù\3\nsetup\rautosave\frequire\0", "config", "AutoSave.nvim")
time([[Config for AutoSave.nvim]], false)
-- Config for: onenord.nvim
time([[Config for onenord.nvim]], true)
try_loadstring("\27LJ\2\n9\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\fonenord\frequire\0", "config", "onenord.nvim")
time([[Config for onenord.nvim]], false)
-- Config for: nvim-treesitter
time([[Config for nvim-treesitter]], true)
try_loadstring("\27LJ\2\nB\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\25lvim.core.treesitter\frequire\0", "config", "nvim-treesitter")
time([[Config for nvim-treesitter]], false)
-- Config for: nvim-cmp
time([[Config for nvim-cmp]], true)
try_loadstring("\27LJ\2\n`\0\0\3\0\6\0\v6\0\0\0009\0\1\0009\0\2\0\15\0\0\0X\1\5Ä6\0\3\0'\2\4\0B\0\2\0029\0\5\0B\0\1\1K\0\1\0\nsetup\18lvim.core.cmp\frequire\bcmp\fbuiltin\tlvim\0", "config", "nvim-cmp")
time([[Config for nvim-cmp]], false)
-- Config for: alpha-nvim
time([[Config for alpha-nvim]], true)
try_loadstring("\27LJ\2\n=\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\20lvim.core.alpha\frequire\0", "config", "alpha-nvim")
time([[Config for alpha-nvim]], false)
-- Config for: nvim-autopairs
time([[Config for nvim-autopairs]], true)
try_loadstring("\27LJ\2\nA\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\24lvim.core.autopairs\frequire\0", "config", "nvim-autopairs")
time([[Config for nvim-autopairs]], false)
-- Config for: nvim-tree.lua
time([[Config for nvim-tree.lua]], true)
try_loadstring("\27LJ\2\n@\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\23lvim.core.nvimtree\frequire\0", "config", "nvim-tree.lua")
time([[Config for nvim-tree.lua]], false)
-- Config for: nvim-colorizer.lua
time([[Config for nvim-colorizer.lua]], true)
try_loadstring("\27LJ\2\n|\0\0\4\0\5\0\b6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\4\0B\0\3\1K\0\1\0\1\0\a\vcss_fn\2\vhsl_fn\2\vrgb_fn\2\rRRGGBBAA\2\vRRGGBB\2\bRGB\2\bcss\2\1\2\0\0\6*\nsetup\14colorizer\frequire\0", "config", "nvim-colorizer.lua")
time([[Config for nvim-colorizer.lua]], false)
-- Config for: LuaSnip
time([[Config for LuaSnip]], true)
try_loadstring("\27LJ\2\n§\3\0\0\n\0\18\2-6\0\0\0'\2\1\0B\0\2\0024\1\3\0009\2\2\0006\4\3\0B\4\1\2'\5\4\0'\6\5\0'\a\6\0'\b\a\0'\t\b\0B\2\a\0?\2\0\0009\2\2\0006\4\t\0B\4\1\2'\5\n\0B\2\3\0029\3\v\0\18\5\2\0B\3\2\2\15\0\3\0X\4\3Ä\21\3\1\0\22\3\1\3<\2\3\0016\3\0\0'\5\f\0B\3\2\0029\3\r\3B\3\1\0016\3\0\0'\5\14\0B\3\2\0029\3\r\0035\5\15\0=\1\16\5B\3\2\0016\3\0\0'\5\17\0B\3\2\0029\3\r\3B\3\1\1K\0\1\0\"luasnip.loaders.from_snipmate\npaths\1\0\0 luasnip.loaders.from_vscode\14lazy_load\29luasnip.loaders.from_lua\17is_directory\rsnippets\19get_config_dir\22friendly-snippets\nstart\vpacker\tpack\tsite\20get_runtime_dir\15join_paths\15lvim.utils\frequire\3ÄÄ¿ô\4\2\0", "config", "LuaSnip")
time([[Config for LuaSnip]], false)
-- Config for: nvim-notify
time([[Config for nvim-notify]], true)
try_loadstring("\27LJ\2\n>\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\21lvim.core.notify\frequire\0", "config", "nvim-notify")
time([[Config for nvim-notify]], false)
-- Config for: lualine.nvim
time([[Config for lualine.nvim]], true)
try_loadstring("\27LJ\2\n?\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\22lvim.core.lualine\frequire\0", "config", "lualine.nvim")
time([[Config for lualine.nvim]], false)
-- Config for: nvim-dap
time([[Config for nvim-dap]], true)
try_loadstring("\27LJ\2\n;\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\18lvim.core.dap\frequire\0", "config", "nvim-dap")
time([[Config for nvim-dap]], false)

-- Command lazy-loads
time([[Defining lazy-load commands]], true)
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file TestSuite lua require("packer.load")({'vim-test'}, { cmd = "TestSuite", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file TestLast lua require("packer.load")({'vim-test'}, { cmd = "TestLast", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file TestVisit lua require("packer.load")({'vim-test'}, { cmd = "TestVisit", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file TestNearest lua require("packer.load")({'vim-test'}, { cmd = "TestNearest", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file TestFile lua require("packer.load")({'vim-test'}, { cmd = "TestFile", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
time([[Defining lazy-load commands]], false)

-- Keymap lazy-loads
time([[Defining lazy-load keymaps]], true)
vim.cmd [[noremap <silent> <localleader>tn <cmd>lua require("packer.load")({'vim-test'}, { keys = "<lt>localleader>tn", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[noremap <silent> <localleader>ts <cmd>lua require("packer.load")({'vim-test'}, { keys = "<lt>localleader>ts", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[noremap <silent> <localleader>tf <cmd>lua require("packer.load")({'vim-test'}, { keys = "<lt>localleader>tf", prefix = "" }, _G.packer_plugins)<cr>]]
time([[Defining lazy-load keymaps]], false)

vim.cmd [[augroup packer_load_aucmds]]
vim.cmd [[au!]]
  -- Filetype lazy-loads
time([[Defining lazy-load filetype autocommands]], true)
vim.cmd [[au FileType markdown ++once lua require("packer.load")({'markdown-preview.nvim'}, { ft = "markdown" }, _G.packer_plugins)]]
vim.cmd [[au FileType rust ++once lua require("packer.load")({'rust-tools.nvim'}, { ft = "rust" }, _G.packer_plugins)]]
vim.cmd [[au FileType rs ++once lua require("packer.load")({'rust-tools.nvim'}, { ft = "rs" }, _G.packer_plugins)]]
time([[Defining lazy-load filetype autocommands]], false)
  -- Event lazy-loads
time([[Defining lazy-load event autocommands]], true)
vim.cmd [[au BufReadPost * ++once lua require("packer.load")({'nvim-ts-context-commentstring'}, { event = "BufReadPost *" }, _G.packer_plugins)]]
vim.cmd [[au BufNew * ++once lua require("packer.load")({'nvim-bqf'}, { event = "BufNew *" }, _G.packer_plugins)]]
vim.cmd [[au BufRead * ++once lua require("packer.load")({'indent-blankline.nvim', 'gitsigns.nvim', 'nvim-bqf', 'Comment.nvim'}, { event = "BufRead *" }, _G.packer_plugins)]]
vim.cmd [[au BufWinEnter * ++once lua require("packer.load")({'toggleterm.nvim', 'which-key.nvim', 'bufferline.nvim'}, { event = "BufWinEnter *" }, _G.packer_plugins)]]
time([[Defining lazy-load event autocommands]], false)
vim.cmd("augroup END")
if should_profile then save_profiles() end

end)

if not no_errors then
  error_msg = error_msg:gsub('"', '\\"')
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
