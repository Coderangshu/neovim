require("copilot").setup({
    suggestion = {
        enabled = true,
        auto_trigger = true,
        debounce = 75, -- Time in milliseconds to debounce suggestions
        keymap = {
          accept = "<C-y>", -- Key mapping to accept a suggestion
          next = "<M-]>", -- Key mapping to go to the next suggestion
          prev = "<M-[>"
        }
    }
})
