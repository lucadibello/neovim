-- Options are automatically loaded before lazy.nvim startup
--
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- ensures Rust LSP is using rust-analyzer
vim.g.lazyvim_rust_diagnostics = "rust-analyzer"

-- Additional rust-analyzer configuration
require("lspconfig").rust_analyzer.setup({
  settings = {
    ["rust-analyzer"] = {
      procMacro = {
        enable = true,
      },
      cargo = {
        loadOutDirsFromCheck = true,
        allFeatures = true,
      },
      diagnostics = {
        enable = true,
        disabled = { "unresolved-proc-macro" },
      },
    },
  },
})
