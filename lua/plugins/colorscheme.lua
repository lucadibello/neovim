return {
  -- add kanagawa colorscheme
  {
    "rebelot/kanagawa.nvim",
    priority = 1000,
    opts = {
      theme = "dragon",
      transparent = true,
    },
  },

  -- Configure LazyVim to use the kanagawa colorscheme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "kanagawa-dragon",
    },
  },
}
