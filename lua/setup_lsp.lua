local on_attach = function(client, bufnr)
    local opts = { noremap = true, silent = true, buffer = bufnr }
    local builtin = require("telescope.builtin")
    vim.keymap.set("n", "<C-[>", builtin.lsp_definitions, opts)
    vim.keymap.set("n", "<C-]>", builtin.lsp_references, opts)
    vim.keymap.set("n", "gi", builtin.lsp_implementations, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<C-.>", vim.lsp.buf.code_action, opts)
end

local servers = {
    clangd = {
        cmd = { "clangd", "--background-index", "--all-scopes-completion" },
        filetypes = { "c", "cpp", "objc", "objcpp" },
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
    },
    pyright = { cmd = { "pyright-langserver", "--stdio" }, filetypes = { "python" } },
    tsserver = { cmd = { "typescript-language-server", "--stdio" }, filetypes = { "javascript", "typescript" } },
    cssls = { cmd = { "vscode-langservers-extracted", "--stdio" }, filetypes = { "css", "html" } },
    jdtls = { cmd = { "jdtls" }, filetypes = { "java" } },
    rust_analyzer = { cmd = { "rust-analyzer" }, filetypes = { "rust" } },
    lua_ls = {
        cmd = { "lua-language-server" },
        filetypes = { "lua" },
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
    },
}

-- Lazy-start LSPs based on filetype
vim.api.nvim_create_autocmd("FileType", {
    callback = function(args)
        local ft = vim.bo[args.buf].filetype
        for name, opts in pairs(servers) do
            if opts.filetypes and vim.tbl_contains(opts.filetypes, ft) then
                -- Check if server is already running
                local clients = vim.lsp.get_clients({ name = name })
                if #clients == 0 then
                    -- Check if binary exists
                    if vim.fn.executable(opts.cmd[1]) == 1 then
                        vim.lsp.start(vim.tbl_extend("force",
                            { name = name, on_attach = on_attach, root_dir = vim.loop.cwd }, opts))
                    else
                        vim.notify("LSP `" .. name .. "` is not installed or not in PATH", vim.log.levels.WARN)
                    end
                end
            end
        end
    end,
})
