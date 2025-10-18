-- core.lua
-- This file contains the core editor settings for Neovim.

-- -----------------------------------------------------------------------------
-- Basic Editor Settings
-- -----------------------------------------------------------------------------

-- Set the leader key to space. The leader key is used for custom shortcuts.
vim.g.mapleader = " "

-- Filetype detection and syntax highlighting
vim.cmd('filetype plugin indent on') -- Enable filetype detection, plugins, and indentation.
vim.cmd('syntax on')                 -- Enable syntax highlighting.

-- Enable true color support for a richer color palette in the terminal.
vim.o.termguicolors = true

-- -----------------------------------------------------------------------------
-- UI and Appearance
-- -----------------------------------------------------------------------------

vim.o.number = true         -- Show absolute line numbers.
vim.o.relativenumber = true -- Show relative line numbers for easier vertical movement.
vim.o.cursorline = true     -- Highlight the line the cursor is on.

vim.o.scrolloff = 8         -- Keep at least 8 lines visible above and below the cursor when scrolling.
vim.o.wrap = false          -- Disable line wrapping to keep long lines on a single line.

vim.o.laststatus = 2        -- Always display the status line.
vim.o.showcmd = true        -- Show the command you are typing in the bottom-right corner.
vim.o.showmatch = true      -- Briefly jump to matching brackets.
vim.o.showmode = false      -- Hide the default mode text (e.g., -- INSERT --) as a status line plugin will handle it.

-- -----------------------------------------------------------------------------
-- Indentation
-- -----------------------------------------------------------------------------

vim.o.expandtab = true      -- Use spaces instead of tab characters.
vim.o.tabstop = 4           -- Number of visual spaces per tab.
vim.o.shiftwidth = 4        -- Number of spaces to use for each step of indentation.
vim.o.softtabstop = 4       -- Number of spaces a <Tab> counts for while editing.
vim.o.autoindent = true     -- Copy indent from the current line when starting a new line.
vim.o.smartindent = true    -- Be smarter about indentation for new lines.

-- -----------------------------------------------------------------------------
-- Search Settings
-- -----------------------------------------------------------------------------

vim.o.hlsearch = true       -- Highlight all search matches.
vim.o.incsearch = true      -- Show search matches incrementally as you type.
vim.o.ignorecase = true     -- Ignore case when searching...
vim.o.smartcase = true      -- ...unless the search pattern contains an uppercase letter.

-- -----------------------------------------------------------------------------
-- File and Backup Settings
-- -----------------------------------------------------------------------------

vim.o.backup = false        -- Do not create backup files.
vim.o.swapfile = false      -- Do not create swap files.
vim.o.undofile = true       -- Enable persistent undo history.

-- -----------------------------------------------------------------------------
-- Autocmds (Automatic Commands)
-- -----------------------------------------------------------------------------

-- Remember cursor position in files
vim.api.nvim_create_autocmd('BufReadPost', {
  pattern = '*',
  callback = function()
    -- Check if the mark '\"' (last exit position) is valid
    if vim.fn.line("'\"") > 1 and vim.fn.line("'\"") <= vim.fn.line('$') then
      -- Go to the last known cursor position
      vim.cmd('normal! g`"')
    end
  end,
  desc = "Restore cursor to last known position"
})


-- NOTE: Folding is best enabled within your nvim-treesitter plugin config.
-- In your treesitter setup file, ensure you have:
--
-- require('nvim-treesitter.configs').setup({
--   -- ... other settings
--   fold = {
--     enable = true,
--   },
-- })
--
-- The autocmd below fixes the issue where folds are not calculated on file load.

local fold_group = vim.api.nvim_create_augroup("MyFoldSettings", { clear = true })
vim.api.nvim_create_autocmd("BufWinEnter", {
  group = fold_group,
  pattern = "*",
  callback = function()
    -- The fix is here: vim.wo (window option) instead of vim.bo (buffer option).
    -- 'foldmethod' is a window-local setting.
    if vim.wo.foldmethod == 'expr' then
      vim.cmd('normal! zX')
    end
  end,
  desc = "Update Treesitter folds on file open"
})

vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter", "BufWritePost", "TextChanged", "TextChangedI" }, {
    callback = function()
        if vim.wo.foldmethod == "expr" and vim.wo.foldexpr == "nvim_treesitter#foldexpr()" then
            vim.schedule(function()
                vim.cmd("silent! zx")
            end)
        end
    end,
})

