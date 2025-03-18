return {
  {
    "benlubas/molten-nvim",
    version = "^1.0.0",
    dependencies = { "3rd/image.nvim" },
    build = ":UpdateRemotePlugins",
  },
  -- Autoamtically convert Jupyter Notebooks to Markdown files to be run with molten
  {
    "GCBallesteros/jupytext.nvim",
    config = true,
  },
  -- LSP features for R, Python, and Rust inside Markdown / Quarto / etc files
  {
    "quarto-dev/quarto-nvim",
    dependencies = {
      "jmbuhr/otter.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      lspFeatures = {
        -- Specify the languages you want to enable:
        languages = { "r", "python", "rust" },
        chunks = "all",
        diagnostics = {
          enabled = true,
          triggers = { "BufWritePost" },
        },
        completion = {
          enabled = true,
        },
      },
      -- Uncomment and customize keymaps if you want to override defaults:
      -- keymap = {
      --   hover = "H",
      --   definition = "gd",
      --   rename = "<leader>rn",
      --   references = "gr",
      --   format = "<leader>gf",
      -- },
      codeRunner = {
        enabled = true,
        default_method = "molten",
      },
    },
  },
}
