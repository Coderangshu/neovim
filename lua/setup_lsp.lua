-- Common on_attach function
local on_attach = function(client, bufnr)
    local opts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set("n", "<C-[>", require("telescope.builtin").lsp_definitions, opts)
    vim.keymap.set("n", "<C-]>", require("telescope.builtin").lsp_references, opts)
    vim.keymap.set("n", "gi", require("telescope.builtin").lsp_implementations, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<C-.>", vim.lsp.buf.code_action, opts)
end

-- Register configs
vim.lsp.config("clangd", {
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
})

vim.lsp.config("pyright", { on_attach = on_attach })
vim.lsp.config("ts_ls", { on_attach = on_attach })
vim.lsp.config("cssls", { on_attach = on_attach })
vim.lsp.config("html", { on_attach = on_attach })
vim.lsp.config("jdtls", { on_attach = on_attach })
vim.lsp.config("rust_analyzer", { on_attach = on_attach })

vim.lsp.config("lua_ls", {
    on_attach = on_attach,
    settings = {
        Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = { globals = { "vim" } },
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
            },
            telemetry = { enable = false },
        },
    },
})

-- Enable all servers
for _, server in ipairs({
    "clangd",
    "pyright",
    "ts_ls",
    "cssls",
    "html",
    "jdtls",
    "rust_analyzer",
    "lua_ls",
}) do
    vim.lsp.enable(server)
end

-- Diagnostics -> quickfix integration
vim.lsp.handlers["textDocument/publishDiagnostics"] = function(_, result, ctx, config)
    local uri = result.uri
    local bufnr = vim.uri_to_bufnr(uri)
    if not bufnr then return end

    vim.lsp.diagnostic.on_publish_diagnostics(_, result, ctx, config)
    vim.diagnostic.setqflist({ open = false })
end
