local wk = require("which-key")

wk.add({
    { "<leader>b", group = "Buffer" },
    { "<leader>c", group = "Copilot" },
    { "<leader>d", group = "Debug" },
    { "<leader>f", group = "Find" },
    { "<leader>g", group = "Git" },
    { "<leader>l", group = "LSP" },
    { "<leader>t", group = "Terminal" },
    { "<leader>q", group = "Quickfix" },
})

-- ---------------------------------------------------------------------
-- Buffer helpers
-- ---------------------------------------------------------------------

local function find_last_open_buffer(exclude_bufnr)
    -- Buffers in current tab (reverse order)
    local wins = vim.api.nvim_tabpage_list_wins(0)
    for i = #wins, 1, -1 do
        local bufnr = vim.api.nvim_win_get_buf(wins[i])
        if bufnr ~= exclude_bufnr
            and vim.api.nvim_buf_is_loaded(bufnr)
            and vim.fn.buflisted(bufnr) == 1
        then
            local ft = vim.bo[bufnr].filetype
            if ft ~= "NvimTree" and ft ~= "neo-tree" and ft ~= "netrw" and ft ~= "oil" then
                return bufnr
            end
        end
    end

    -- Fallback: all listed buffers (reverse order)
    local all_bufs = vim.fn.getbufinfo({ buflisted = 1 })
    for i = #all_bufs, 1, -1 do
        local bufnr = all_bufs[i].bufnr
        if bufnr ~= exclude_bufnr then
            local ft = vim.bo[bufnr].filetype
            if ft ~= "NvimTree" and ft ~= "neo-tree" and ft ~= "netrw" and ft ~= "oil" then
                return bufnr
            end
        end
    end

    return nil
end

local function close_buffer_to_last()
    local cur = vim.api.nvim_get_current_buf()
    local target = find_last_open_buffer(cur)
    if target then
        pcall(vim.api.nvim_set_current_buf, target)
        vim.cmd("bdelete " .. tostring(cur))
    else
        vim.cmd("bdelete")
    end
end

-- ---------------------------------------------------------------------
-- NvimTree toggle
-- ---------------------------------------------------------------------

local function get_nvim_tree_win()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.bo[buf].filetype == "NvimTree" then
            return win
        end
    end
    return nil
end

local function toggle_nvim_tree()
    local tree_win = get_nvim_tree_win()
    if tree_win then
        local current_win = vim.api.nvim_get_current_win()
        if current_win == tree_win then
            vim.cmd("NvimTreeClose")
        else
            vim.api.nvim_set_current_win(tree_win)
        end
    else
        vim.cmd("NvimTreeOpen")
    end
end

-- ---------------------------------------------------------------------
-- Copilot Tab key
-- ---------------------------------------------------------------------

local function tab_key()
    if require("copilot.suggestion").is_visible() then
        require("copilot.suggestion").accept()
    else
        vim.api.nvim_feedkeys(
            vim.api.nvim_replace_termcodes("<Tab>", true, true, true),
            "n",
            false
        )
    end
end

-- ---------------------------------------------------------------------
-- Keymaps
-- ---------------------------------------------------------------------

local keymap = vim.keymap.set

local mappings = {
    -- Basic
    { "<C-o>", toggle_nvim_tree, desc = "Open Tree" },
    { "<C-`>", ":ToggleTerm<CR>", desc = "Toggle(Close) Terminal" },
    { "<C-`>", "<C-\\><C-n>:ToggleTerm<CR>", desc = "Toggle(Open) Terminal", mode = "t" },

    { "<C-b>", close_buffer_to_last, desc = "Close Buffer → Last open buffer" },

    { "<C-s>", ":w<CR>", desc = "Save File" },
    { "<C-A-s>", ":w | bd<CR>", desc = "Save and Close Buffer" },

    -- Aerial
    { "<leader>a", "<cmd>AerialToggle!<CR>", desc = "Aerial Toggle" },
    { "{", "<cmd>AerialPrev<CR>", desc = "Previous Segment" },
    { "}", "<cmd>AerialNext<CR>", desc = "Next Segment" },

    -- Copy/paste
    { "<C-c>", '"+y', desc = "Copy to System Clipboard", mode = "v" },
    { "<C-a>", "ggVG", desc = "Select All" },
    { "<C-p>", '"o<Esc>"+p', desc = "Paste from Clipboard" },

    -- Quickfix
    { "<leader>qa", function() vim.lsp.buf.code_action() end, desc = "Quickfix Actions" },
    { "<leader>qo", ":copen<CR>", desc = "Open Quickfix List" },
    { "<leader>qc", ":cclose<CR>", desc = "Close Quickfix List" },
    { "<leader>qn", ":cnext<CR>", desc = "Next Error/Warning" },
    { "<leader>qp", ":cprev<CR>", desc = "Previous Error/Warning" },

    -- Git
    { "<leader>gs", ":Gitsigns show<CR>", desc = "Show Status" },
    { "<leader>ga", ":Gitsigns stage_hunk<CR>", desc = "Stage Change" },
    { "<leader>gu", ":Gitsigns undo_stage_hunk<CR>", desc = "Undo Stage Change" },
    { "<leader>gd", function() require("gitsigns").diffthis("HEAD") end, desc = "Show diff with prev commit" },
    { "<leader>gp", ":Gitsigns preview_hunk<CR>", desc = "Preview current hunk diffs" },

    -- Copilot
    { "<leader>ct", ":Copilot toggle<CR>", desc = "Toggle Copilot" },
    { "<Tab>", tab_key, desc = "Accept Changes", mode = "i" },

    -- Comment
    { "<C-'>", function() require("Comment.api").toggle.linewise.current() end,
      desc = "Toggle Comment", mode = "n" },
    { "<C-'>", function()
        local esc = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)
        vim.api.nvim_feedkeys(esc, "x", false)
        require("Comment.api").toggle.linewise(vim.fn.visualmode())
    end, desc = "Toggle Comment", mode = "v" },
}

-- register mappings
for _, map in ipairs(mappings) do
    keymap(map.mode or "n", map[1], map[2], {
        noremap = true, silent = true, desc = map.desc
    })
end

-- Ctrl+Number buffer switch
for i = 1, 9 do
    keymap("n", "<C-" .. i .. ">", ":BufferLineGoToBuffer " .. i .. "<CR>", {
        noremap = true, silent = true, desc = "Switch to Tab " .. i
    })
end

