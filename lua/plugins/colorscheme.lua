return {
  -- add rose-pine colorscheme
  {
    "rebelot/kanagawa.nvim",
    priority = 1000,
    opts = {
      undercurl = true, -- enable undercurls
      commentStyle = { italic = true },
      functionStyle = { italic = true },
      keywordStyle = { italic = true },
      statementStyle = { bold = true },
      typeStyle = { bold = true },
      dim_inactive = true,
      transparent = false,
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
