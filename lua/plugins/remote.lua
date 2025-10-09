return {
  "amitds1997/remote-nvim.nvim",
  version = "*",
  dependencies = {
    "nvim-lua/plenary.nvim", -- For standard functions
    "MunifTanjim/nui.nvim", -- To build the plugin UI
    "nvim-telescope/telescope.nvim", -- For picking b/w different remote methods
  },
  opts = {
    remote = {
      remote_dir = "~/.config/nvim-remote",
      copy_dirs = {
        config = {
          -- copy over important LazyVim config files
          dirs = { "lua", "init.lua", "lazyvim.json", "stylua.toml" },
        },
      },
    },
  },
}
