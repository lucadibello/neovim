return {
  {
    "folke/sidekick.nvim",
    opts = {
      -- enable tmux backend for session persistence
      cli = {
        mux = {
          backend = "tmux",
          enabled = true,
        },
      },
    },
  },
}
