require("nvim-treesitter.configs").setup({
    ensure_installed = { "c", "cpp", "lua", "python", "javascript", "typescript", "bash", "json", "html", "css", "rust" },
    highlight = { enable = true },
    indent = { enable = true },
    fold = { enable = true },
})
