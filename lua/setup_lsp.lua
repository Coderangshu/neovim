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

-- 1. Dynamically determine the best clangd path
local clangd_bin = "clangd" -- Default system path (Works perfectly on Linux)

-- If we are on a Mac, and the Homebrew LLVM version exists, use that to bypass Apple's default
if vim.fn.has("mac") == 1 and vim.fn.executable("/opt/homebrew/opt/llvm/bin/clangd") == 1 then
    clangd_bin = "/opt/homebrew/opt/llvm/bin/clangd"
end

local servers = {
    -- 2. Pass the dynamic variable into your cmd table
    clangd = {
        cmd = { clangd_bin, "--background-index", "--all-scopes-completion" },
        filetypes = { "c", "cpp", "objc", "objcpp" },
        capabilities = { offsetEncoding = { "utf-16" } },
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

-- Define what files indicate the "root" of a project
local root_markers = { ".git", "Makefile", "package.json", "Cargo.toml", "pyproject.toml", "compile_commands.json" }

-- Lazy-start LSPs based on filetype
vim.api.nvim_create_autocmd("FileType", {
    callback = function(args)
        local ft = vim.bo[args.buf].filetype
        local current_file_path = vim.api.nvim_buf_get_name(args.buf)

        -- Smart Root Discovery (Safe from 'nil' errors)
        local root_match = vim.fs.find(root_markers, {
            upward = true,
            path = vim.fs.dirname(current_file_path)
        })[1]

        -- If a root marker was found, get its directory. Otherwise, fallback to cwd.
        local root_dir = root_match and vim.fs.dirname(root_match) or vim.fn.getcwd()

        for name, opts in pairs(servers) do
            if opts.filetypes and vim.tbl_contains(opts.filetypes, ft) then
                -- Check if server is already running for this specific root directory
                local clients = vim.lsp.get_clients({ name = name })
                local is_running = false
                for _, client in ipairs(clients) do
                    if client.config.root_dir == root_dir then
                        is_running = true
                        break
                    end
                end

                if not is_running then
                    -- Check if binary exists
                    if vim.fn.executable(opts.cmd[1]) == 1 then
                        -- Merge our smart root_dir and on_attach into the server options
                        local server_config = vim.tbl_extend("force", {
                            name = name,
                            on_attach = on_attach,
                            root_dir = root_dir
                        }, opts)
                        vim.lsp.start(server_config)
                    else
                        vim.notify("LSP `" .. name .. "` is not installed or not in PATH", vim.log.levels.WARN)
                    end
                end
            end
        end
    end,
})
