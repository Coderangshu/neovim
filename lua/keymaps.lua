local wk = require("which-key")

wk.add({
  { "<leader>b", group = "Buffer" }, -- Groups all Buffer-related mappings under "b"
  { "<leader>c", group = "Copilot" }, -- Groups all Copilot-related mappings under "c"
  { "<leader>d", group = "Debug" }, -- Debugging tools
  { "<leader>f", group = "Find" }, -- For Telescope, file searching, etc.
  { "<leader>g", group = "Git" },  -- Groups all Git-related mappings under "g"
  { "<leader>l", group = "LSP" },  -- LSP commands
  { "<leader>t", group = "Terminal" }, -- Terminal-related commands
  { "<leader>q", group = "Quickfix" }, -- Quickfix commands
}) 

local function get_nvim_tree_win()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].filetype == "NvimTree" then
      return win
    end
  end
  return nil
end

-- Toggle behavior:
-- - If NvimTree is not open, open it.
-- - If NvimTree is open and focused, close it.
-- - If NvimTree is open but not focused, switch focus to it.
function toggle_nvim_tree()
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

-- TAB key behavior:
-- If suggection is visible, autocomplete
-- Else insert TAB space
local function tab_key()
  if require("copilot.suggestion").is_visible() then
    require("copilot.suggestion").accept()
  else
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, true, true), "n", false)
  end
end

local keymap = vim.keymap.set

local mappings = {
  -- Basic Tools
  { "<C-o>", ":lua toggle_nvim_tree()<CR>", desc = "Open Tree" },
  { "<C-`>", ":ToggleTerm<CR>", desc = "Toggle(Close) Terminal" },
  { "<C-`>", "<C-\\><C-n>:ToggleTerm<CR>", desc = "Toggle(Open) Terminal", mode = "t" },
  { "<C-b>", ":bdelete<CR>", desc = "Close Tab" },
  { "<C-s>", ":w<CR>", desc = "Save File" },
  { "<C-A-s>", ":w | bd<CR>", desc = "Save and Close Buffer" },
  { "<leader>a", "<cmd>AerialToggle!<CR>", desc = "Aerial Toggle"},

  -- copy paste shortcuts
  { "<C-c>", '"+y', desc = "Copy to System Clipboard", mode = "v" },
  { "<C-a>", "ggVG", desc = "Select All" },
  { "<C-p>", '"o<Esc>"+p', desc = "Paste from Clipboard" },

  -- Key mappings for quickfix navigation
  { "<leader>qa", ":lua vim.lsp.buf.code_action()<CR>", desc = "Quickfix Actions" },
  { "<leader>qo", ":copen<CR>", desc = "Open Quickfix List" },
  { "<leader>qc", ":cclose<CR>", desc = "Close Quickfix List" },
  { "<leader>qn", ":cnext<CR>", desc = "Next Error/Warning" },
  { "<leader>qp", ":cprev<CR>", desc = "Previous Error/Warning" },

  -- Key mappings for git 
  { "<leader>gs", ":Gitsigns show<CR>", desc = "Show Status" },
  { "<leader>ga", ":Gitsigns stage_hunk<CR>", desc = "Stage Change" },
  { "<leader>gu", ":Gitsigns undo_stage_hunk<CR>", desc = "Undo Stage Change" },

  -- Key mappings for copilot
  { "<leader>ct", ":Copilot toggle<CR>", desc = "Toggle Copilot" },
  { "<Tab>", tab_key, desc = "Accept Changes", mode = "i" },
}

-- Register key mappings
for _, map in ipairs(mappings) do
  keymap(map.mode or "n", map[1], map[2], { noremap = true, silent = true, desc = map.desc })
end

-- Register keys for tabs switching (Ctrl + Number)
for i = 1, 9 do
  keymap("n", "<C-" .. i .. ">", ":BufferLineGoToBuffer " .. i .. "<CR>", { noremap = true, silent = true, desc = "Switch to Tab " .. i })
end

