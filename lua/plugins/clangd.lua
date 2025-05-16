# This snippet allows to fix the clangd offsetEncoding issue.
return {
  "neovim/nvim-lspconfig",
  opts = {
    setup = {
      clangd = {
        capabilities = {
          offsetEncoding = { "utf-16" },
        },
      }
    },
  },
}
