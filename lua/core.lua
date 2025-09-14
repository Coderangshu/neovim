-- Basic settings
vim.cmd('filetype on')        -- Enable file type detection
vim.cmd('filetype plugin on') -- Enable plugins for detected file types
vim.cmd('filetype indent on') -- Load indent files for detected file types
vim.cmd('syntax on')          -- Turn syntax highlighting on
vim.g.mapleader = " "         -- Set the leader key to a space
vim.o.laststatus = 2          -- Always show status line
vim.o.mousemoveevent = true   -- Capture mouse movement

-- Line numbers and cursor
vim.o.relativenumber = true -- Show relative line numbers
vim.o.number = true         -- Show absolute line number for the current line
vim.o.cursorline = true     -- Highlight the current line

-- Indentation
vim.o.shiftwidth = 4   -- Set shift width to 4 spaces
vim.o.tabstop = 4      -- Set tab width to 4 columns
vim.o.expandtab = true -- Use spaces instead of tabs
vim.o.autoindent = true -- Auto-indent new lines
vim.o.smartindent = true -- Smart indentation
vim.o.smarttab = true   -- Smart tabbing
vim.o.softtabstop = 4   -- Number of spaces a <Tab> counts for while performing editing operations
vim.o.cindent = true    -- Enable C-style indentation
vim.o.indentexpr = '' -- Use custom C indentation function

-- Backup and scrolling
vim.o.backup = false -- Do not save backup files
vim.o.scrolloff = 10 -- Keep 10 lines above/below the cursor when scrolling
vim.o.wrap = false   -- Do not wrap lines

-- Search
vim.o.incsearch = true  -- Incremental search
vim.o.ignorecase = true -- Ignore case in search
vim.o.smartcase = true  -- Case-sensitive search if uppercase is used
vim.o.hlsearch = true   -- Highlight search results

-- UI
vim.o.showcmd = true                                                               -- Show partial command in the last line
vim.o.showmode = false                                                             -- Do not show mode (handled by lightline)
vim.o.showmatch = true                                                             -- Show matching brackets
vim.o.wildmenu = true                                                              -- Enable command-line completion menu
vim.o.wildmode = 'list:longest'                                                    -- Bash-like completion
vim.o.wildignore = '*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx' -- Ignore certain file types
vim.o.showtabline = 2                                                              -- Show tab on top always
vim.o.termguicolors = true                                                       -- Use terminal colors

-- Folding
vim.o.foldmethod = 'expr'                  -- Set folding method to syntax
vim.o.foldexpr = "nvim_treesitter#foldexpr()"
vim.o.foldenable = true                    -- Enable folding
vim.o.foldlevel = 99                       -- Set fold level to 99
vim.o.viewoptions = "folds,options,cursor" -- Ensure folds are saved

-- Remember previous fold state
-- vim.cmd([[
--   augroup RememberFolds
--     autocmd!
--     autocmd BufWinLeave * silent! mkview
--     autocmd BufWinEnter * silent! loadview
--   augroup END
-- ]])


-- Remember cursor position
vim.api.nvim_create_autocmd('BufReadPost', {
    pattern = '*',
    callback = function()
        if vim.fn.line("'\"") > 1 and vim.fn.line("'\"") <= vim.fn.line('$') then
            vim.cmd('normal! g`"')
        end
    end,
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

