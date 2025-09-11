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

lspconfig.clangd.setup {
  on_attach = on_attach,
  cmd = { "clangd", "--background-index", "--all-scopes-completion" },
  init_options = {
    fallbackFlags = {
      "-std=c++14",
      "-I/opt/homebrew/Cellar/gcc/15.1.0/include/c++/15",
      "-I/opt/homebrew/Cellar/gcc/15.1.0/include/c++/15/aarch64-apple-darwin24",
      "-I/opt/homebrew/Cellar/gcc/15.1.0/include/c++/15/backward",
      "-I/opt/homebrew/Cellar/gcc/15.1.0/lib/gcc/current/gcc/aarch64-apple-darwin24/15/include",
      "-I/opt/homebrew/Cellar/gcc/15.1.0/lib/gcc/current/gcc/aarch64-apple-darwin24/15/include-fixed",
      "-I/Library/Developer/CommandLineTools/SDKs/MacOSX15.sdk/usr/include",
      "-I/Library/Developer/CommandLineTools/SDKs/MacOSX15.sdk/System/Library/Frameworks",
    },
  },
}

lspconfig.pyright.setup { on_attach = on_attach }
lspconfig.ts_ls.setup { on_attach = on_attach }
lspconfig.cssls.setup { on_attach = on_attach }
lspconfig.html.setup { on_attach = on_attach }
lspconfig.jdtls.setup { on_attach = on_attach }
lspconfig.rust_analyzer.setup { on_attach = on_attach }
lspconfig.lua_ls.setup {
  on_attach = on_attach,
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },  -- Use LuaJIT for Neovim
      diagnostics = { globals = { "vim" } },  -- Recognize the `vim` global
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,  -- Avoid third-party library prompts
      },
      telemetry = { enable = false },
    },
  },
}

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
end
