local lspconfig = require("lspconfig")
local on_attach = function(client, bufnr)
local opts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set("n", "<C-[>", require('telescope.builtin').lsp_definitions, opts)
    vim.keymap.set("n", "<C-]>", require('telescope.builtin').lsp_references, opts)
    vim.keymap.set("n", "gi", require('telescope.builtin').lsp_implementations, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<C-.>", vim.lsp.buf.code_action, opts)
end

lspconfig.clangd.setup { on_attach = on_attach }
lspconfig.pyright.setup { on_attach = on_attach }
lspconfig.ts_ls.setup { on_attach = on_attach }
lspconfig.cssls.setup { on_attach = on_attach }
lspconfig.html.setup { on_attach = on_attach }
lspconfig.jdtls.setup { on_attach = on_attach }

-- Enable LSP-based formatting on save
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    vim.lsp.buf.format({ async = false }) -- Format synchronously
  end,
})

-- Automatically populate quickfix list with diagnostics
vim.lsp.handlers["textDocument/publishDiagnostics"] = function(_, result, ctx, config)
  local uri = result.uri
  local bufnr = vim.uri_to_bufnr(uri)

  if not bufnr then
    return
  end

  local diagnostics = result.diagnostics

  -- Set diagnostics in buffer
  vim.lsp.diagnostic.on_publish_diagnostics(_, result, ctx, config)

  -- Update quickfix list with current diagnostics
  vim.diagnostic.setqflist({ open = false })

  -- Optionally, you can set location list for the current window
  -- vim.diagnostic.setloclist({ open = false })

  -- Optionally, print the number of errors and warnings
  -- vim.api.nvim_command('echohl WarningMsg')
  -- vim.api.nvim_command('echom "Diagnostics updated"')
  -- vim.api.nvim_command('echohl None')
end
