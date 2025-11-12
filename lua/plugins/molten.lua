return {
  {
    "benlubas/molten-nvim",
    dev = false,
    ft = { "quarto", "python", "jupyter", "ipynb", "qmd" },
    build = ":UpdateRemotePlugins",
    init = function()
      vim.g.molten_image_provider = "image.nvim"
      vim.g.molten_auto_open_output = true
      vim.g.molten_auto_open_html_in_browser = false
      vim.g.molten_tick_rate = 200
      vim.g.molten_wrap_output = true

      -- -- Output as virtual text. Allows outputs to always be shown, works with images, but can
      -- -- be buggy with longer images
      vim.g.molten_virt_text_output = true

      -- this will make it so the output shows up below the \`\`\` cell delimiter
      vim.g.molten_virt_lines_off_by_1 = true
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
      { "<localleader>me", ":MoltenEvaluateOperator<CR>", desc = "Run operator selection", silent = true },
      { "<localleader>ml", ":MoltenEvaluateLine<CR>", desc = "Evaluate line", silent = true },
      { "<localleader>mr", ":MoltenReevaluateCell<CR>", desc = "Re-evaluate cell", silent = true },
      {
        "<localleader>mR",
        ":<C-u>MoltenEvaluateVisual<CR>gv",
        desc = "Evaluate visual selection",
        silent = true,
      },
      { "<localleader>md", ":MoltenDelete<CR>", desc = "Molten delete cell", silent = true },
      { "<localleader>mh", ":MoltenHideOutput<CR>", desc = "Hide output", silent = true },
      { "<localleader>ms", ":noautocmd MoltenEnterOutput<CR>", desc = "Show/enter output", silent = true },
      { "<localleader>mx", ":MoltenOpenInBrowser<CR>", desc = "Open output in browser", silent = true },
    },
  },
}
