-- Set up lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- Use the stable branch
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Set up plugins
require("lazy").setup({
  { "folke/tokyonight.nvim", config = function() vim.cmd("colorscheme tokyonight-night") end }, -- neovim theme
  { "nvim-lualine/lualine.nvim", dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function() require("lualine").setup({ options = { theme = "tokyonight" } }) end }, -- bottom statusline
  { "nvim-tree/nvim-tree.lua", dependencies = { "nvim-tree/nvim-web-devicons" }, 
    config = function() require("nvim-tree").setup({ view = { width = 30 } }) end }, -- file explorer
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate", config = function() end }, -- nvim enhancer for various languages
  { "neovim/nvim-lspconfig", config = function() end }, -- lsp
  { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" },
    config = function() require('telescope').setup{} end }, -- reference finder
  { "akinsho/toggleterm.nvim", config = function() require("toggleterm").setup {} end }, -- terminal at bottom
  { "stevearc/aerial.nvim", dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, }, -- code outline
})

