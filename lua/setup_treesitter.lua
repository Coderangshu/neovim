require("nvim-treesitter.configs").setup({
    ensure_installed = { "c", "cpp", "lua", "python", "javascript", "typescript", "bash", "json", "html", "css", "rust" },
    highlight = { enable = true },
    indent = { enable = false,
               disable = { "cpp", "javascript", "typescript" }  -- Disable indent for cpp and js/ts due to issues
    },
    fold = { enable = true },
})
