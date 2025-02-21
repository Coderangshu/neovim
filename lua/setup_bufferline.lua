require("bufferline").setup {
  options = {
      separator_style = "slant", -- or "padded_slant", "thick", "thin"
      always_show_bufferline = true, -- Always show the tab bar
      show_tab_indicators = false, -- Disable the extra numbers on the right
      diagnostics = "nvim_lsp", -- Optional: Show LSP diagnostics on tabs
      show_close_icon = false, -- Hide the global close button
      show_buffer_close_icons = true, -- Enable close buttons per buffer
      hover = {
        enabled = true,
        delay = 200, -- Delay before showing close button (in ms)
        reveal = { "close" } -- Show close button on hover
      },
      numbers = function(opts)
          return string.format("%s", opts.raise(opts.ordinal))
      end,
      offsets = {
        {
          filetype = "NvimTree", -- Sidebar for NvimTree
          text = "File Explorer",
          highlight = "Directory",
          text_align = "left"
        },
        {
          filetype = "undotree", -- Sidebar for Undotree
          text = "Undo History",
          highlight = "Directory",
          text_align = "left"
        }
      },
      diagnostics_indicator = function(count, level, diagnostics_dict, context)
        local icon = level:match("error") and " " or " "
        return " " .. icon .. count
      end
    },
    highlights = {
      fill = {
        bg = "#1e1e2e", -- Background of the tabline
      },
      buffer_selected = {
        fg = "#ffffff", -- Selected tab text color
        bold = true,
      },
      buffer_visible = {
        fg = "#c0caf5", -- Unselected tab text
        bg = "#3b4261",
      },
    }
}
