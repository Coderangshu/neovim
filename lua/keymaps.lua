local wk = require("which-key")
local keymap = vim.keymap.set

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

keymap("t", "<C-`>", "<C-\\><C-n>:ToggleTerm<CR>", { noremap = true, silent = true }) -- ToggleTerm Open

local mappings = {
  -- Basic Tools
  { "<C-o>", ":lua toggle_nvim_tree()<CR>", desc = "Open Tree" },
  { "<C-`>", ":ToggleTerm<CR>", desc = "Toggle Terminal" },
  { "<C-b>", ":bdelete<CR>", desc = "Close Tab" },
  { "<C-s>", ":w<CR>", desc = "Save File" },
  { "<C-A-s>", ":w | bd<CR>", desc = "Save and Close Buffer" },

  -- copy paste shortcuts
  { "<C-c>", '"+y', mode = "v", desc = "Copy to System Clipboard" },
  { "<C-a>", "ggVG", desc = "Select All" },
  { "<C-p>", '"o<Esc>"+p', desc = "Paste from Clipboard" },

  -- Key mappings for quickfix navigation
  { "<leader>qo", ":copen<CR>", desc = "Open Quickfix List" },
  { "<leader>qc", ":cclose<CR>", desc = "Close Quickfix List" },
  { "<leader>qn", ":cnext<CR>", desc = "Next Error/Warning" },
  { "<leader>qp", ":cprev<CR>", desc = "Previous Error/Warning" },

  -- Key mappings for git stage and unstage
  { "<leader>gs", ":Gitsigns stage_hunk<CR>", desc = "Stage Change" },
  { "<leader>gu", ":Gitsigns undo_stage_hunk<CR>", desc = "Undo Stage Change" },
}

-- Register key mappings
for _, map in ipairs(mappings) do
  keymap(map.mode or "n", map[1], map[2], { noremap = true, silent = true, desc = map.desc })
end

-- Register keys for tabs switching (Ctrl + Number)
for i = 1, 9 do
  keymap("n", "<C-" .. i .. ">", ":BufferLineGoToBuffer " .. i .. "<CR>", { noremap = true, silent = true, desc = "Switch to Tab " .. i })
end

-- Register TAB key for autocompletion if suggestion is visible, otherwise insert TAB
keymap("i", "<Tab>", function()
  if require("copilot.suggestion").is_visible() then
    require("copilot.suggestion").accept()
  else
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, true, true), "n", false)
  end
end, { silent = true })
