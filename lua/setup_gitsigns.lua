require('gitsigns').setup {
  auto_attach = true, -- Automatically attach to buffer (optional)
  numhl = true,  -- Highlight line numbers
  linehl = false, -- Highlight changed lines (optional)
  watch_gitdir = { interval = 1000, follow_files = true },
  current_line_blame = true, -- Show git blame inline (enable if needed)
  sign_priority = 6,
  update_debounce = 200,
  max_file_length = 40000, -- Disable for large files
}

