local keymap = vim.api.nvim_set_keymap

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

-- Basic Tools
keymap('n', '<C-o>', ":lua toggle_nvim_tree()<CR>", { noremap = true, silent = true }) -- Open Tree
keymap("n", "<C-`>", ":ToggleTerm<CR>", { noremap = true, silent = true }) -- ToggleTerm Open
keymap("t", "<C-`>", "<C-\\><C-n>:ToggleTerm<CR>", { noremap = true, silent = true }) -- ToggleTerm Open
keymap("n", "<C-b>", ":bdelete<CR>", { noremap = true, silent = true })


-- copy paste shortcuts
keymap('v', '<C-c>', '"+y', { noremap = true, silent = true }) -- For copy to system
keymap('n', '<C-a>', 'ggVG', { noremap = true, silent = true }) -- For selecting all
keymap('n', '<C-p>', '"o<Esc>"+p', { noremap = true, silent = true }) -- For pasting from system

-- Key mappings for quickfix navigation
keymap('n', '<leader>qo', ':copen<CR>', { noremap = true, silent = true }) -- Open quickfix list
keymap('n', '<leader>qc', ':cclose<CR>', { noremap = true, silent = true }) -- Close quickfix list
keymap('n', '<leader>qn', ':cnext<CR>', { noremap = true, silent = true }) -- Goto next error/warning
keymap('n', '<leader>qp', ':cprev<CR>', { noremap = true, silent = true }) -- Goto previous error/warning
