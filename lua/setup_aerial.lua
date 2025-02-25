local keymap = vim.keymap.set

require("aerial").setup({
  on_attach = function(bufnr)
    keymap("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
    keymap("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
  end,
})
