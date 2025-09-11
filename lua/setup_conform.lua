require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "black" },
    javascript = { "prettier" },
    typescript = { "prettier" },
    typescriptreact = { "prettier" },
    javascriptreact = { "prettier" },
    css = { "prettier" },
    html = { "prettier" },
    json = { "prettier" },
    c = { "clang_format" },
    cpp = { "clang_format" },
    java = { "clang_format" }, -- jdtls does not format directly
    rust = { "rustfmt" },
  },

  -- Autoformat on save
  format_on_save = {
    lsp_fallback = true,
    timeout_ms = 1000,
  },
})

-- Map filetypes to binaries
local ft_to_bin = {
  lua = "stylua",
  python = "black",
  javascript = "prettier",
  typescript = "prettier",
  typescriptreact = "prettier",
  javascriptreact = "prettier",
  css = "prettier",
  html = "prettier",
  json = "prettier",
  c = "clang_format",
  cpp = "clang_format",
  java = "clang_format",
  rust = "rustfmt",
}

-- Map binaries to descriptions
local bin_desc = {
  stylua = "Lua formatter",
  black = "Python formatter",
  prettier = "JS/TS/CSS/HTML/JSON formatter",
  clang_format = "C/C++/Java formatter",
  rustfmt = "Rust formatter",
}

-- Notify only for the current buffer's filetype
local ft = vim.bo.filetype
local bin = ft_to_bin[ft]
if bin and vim.fn.executable(bin) == 0 then
  vim.notify(string.format(
    "[Conform] %s (%s) not found in PATH! Install it to enable formatting for %s files.",
    bin, bin_desc[bin] or bin, ft
  ), vim.log.levels.WARN)
end

-- Force formatters to 4 spaces

-- Lua
require("conform").formatters.stylua = {
  prepend_args = { "--indent-type", "Spaces", "--indent-width", "4" },
}

-- Python (Black doesn’t support indent width → only line length!)
require("conform").formatters.black = {
  prepend_args = { "--line-length", "88" },
}

-- Prettier (JS, TS, CSS, HTML, JSON, etc.)
require("conform").formatters.prettier = {
  prepend_args = { "--tab-width", "4", "--use-tabs", "false" },
}

-- Clang-format (C, C++, Java)
require("conform").formatters.clang_format = {
  prepend_args = { "-style={IndentWidth: 4, UseTab: Never}" },
}

-- Rustfmt
require("conform").formatters.rustfmt = {
  prepend_args = { "--config", "tab_spaces=4" },
}

