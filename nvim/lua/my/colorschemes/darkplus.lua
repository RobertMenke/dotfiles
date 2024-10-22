return {
  "lunarvim/darkplus.nvim",
  name = "darkplus",
  config = function()
    require("darkplus").setup()
    vim.cmd "colorscheme darkplus"
  end,
}
