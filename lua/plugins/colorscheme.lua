return {
  -- tokyonight.nvim theme
  -- {
  --   "folke/tokyonight.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   opts = {},
  -- },

  -- High-contrast, futuristic & vibrant colorscheme
  {
    "scottmckendry/cyberdream.nvim",
    opts = {
      transparent = true,
      italic_comments = true,
      hide_fillchars = false,
      borderless_telescope = true,
      terminal_colors = true,
    },
  },

  -- Configure LazyVim to use the kanagawa colorscheme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "cyberdream",
    },
  },
}
