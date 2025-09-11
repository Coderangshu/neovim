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
  { "nvim-lualine/lualine.nvim", dependencies = { "nvim-tree/nvim-web-devicons", "AndreM222/copilot-lualine" }, }, -- bottom statusline
  { "nvim-tree/nvim-tree.lua", dependencies = { "nvim-tree/nvim-web-devicons" }, 
    config = function() require("nvim-tree").setup({ view = { width = 30 } }) end }, -- file explorer
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate", config = function() end }, -- nvim enhancer for various languages
  { "neovim/nvim-lspconfig", config = function() end }, -- lsp
  { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" },
    config = function() require('telescope').setup{} end }, -- reference finder
  { "akinsho/toggleterm.nvim", config = function() require("toggleterm").setup {} end }, -- terminal at bottom
  { "stevearc/aerial.nvim", dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    config = function() require("aerial").setup() end }, -- code outline
  { "zbirenbaum/copilot.lua" }, -- github copilot
  { "hrsh7th/nvim-cmp", dependencies = { "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-buffer", "hrsh7th/cmp-path", "hrsh7th/cmp-cmdline", "L3MON4D3/LuaSnip" }, }, -- autocompletion
  {'akinsho/bufferline.nvim', version = "*", dependencies = 'nvim-tree/nvim-web-devicons', config = function() require("bufferline").setup{} end }, -- buffer line
  {'lewis6991/gitsigns.nvim', dependencies = { 'nvim-lua/plenary.nvim' }, config = function() require('gitsigns').setup() end }, -- git integration
  { "folke/which-key.nvim", config = function() require("which-key").setup() end }, -- keybinding helper
  { "numToStr/Comment.nvim", config = function() require('Comment').setup() end }, -- easy commenting
  { "stevearc/conform.nvim" }, -- Formatter manager
})

