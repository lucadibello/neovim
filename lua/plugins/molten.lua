return {
  {
    "benlubas/molten-nvim",
    dev = false,
    ft = { "quarto", "python", "jupyter", "ipynb", "qmd" },
    build = ":UpdateRemotePlugins",
    init = function()
      vim.g.molten_image_provider = "image.nvim"
      vim.g.molten_auto_open_output = true
      vim.g.molten_auto_open_html_in_browser = true
      vim.g.molten_tick_rate = 200
    end,
    keys = {
      {
        "<localleader>mi",
        function()
          local cfg = require("quarto.config").config
          cfg.codeRunner.default_method = "molten"
          vim.cmd("MoltenInit")
        end,
        desc = "Initialize molten",
      },
      {
        "<localleader>md",
        function()
          local cfg = require("quarto.config").config
          cfg.codeRunner.default_method = "slime"
          vim.cmd("MoltenDeinit")
        end,
        desc = "Stop molten",
      },
      { "<localleader>mp", "<cmd>MoltenImagePopup<CR>", desc = "Molten image popup" },
      { "<localleader>mb", "<cmd>MoltenOpenInBrowser<CR>", desc = "Molten open in browser" },
      { "<localleader>mh", "<cmd>MoltenHideOutput<CR>", desc = "Molten hide output" },
      { "<localleader>ms", "<cmd>noautocmd MoltenEnterOutput<CR>", desc = "Molten show/enter output" },
    },
  },
}
