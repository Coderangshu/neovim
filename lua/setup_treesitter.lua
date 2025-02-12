require("nvim-treesitter.configs").setup({
    ensure_installed = { "c", "lua", "python", "javascript", "typescript", "bash", "json", "html", "css" },
    highlight = { enable = true },
    indent = { enable = true },
    fold = { enable = true },
})
