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
    },
  },
}

-- Suggested keybingings:
-- vim.keymap.set("n", "<localleader>e", ":MoltenEvaluateOperator<CR>", { silent = true, desc = "run operator selection" })
-- vim.keymap.set("n", "<localleader>rl", ":MoltenEvaluateLine<CR>", { silent = true, desc = "evaluate line" })
-- vim.keymap.set("n", "<localleader>rr", ":MoltenReevaluateCell<CR>", { silent = true, desc = "re-evaluate cell" })
-- vim.keymap.set("v", "<localleader>r", ":<C-u>MoltenEvaluateVisual<CR>gv", { silent = true, desc = "evaluate visual selection" })
-- vim.keymap.set("n", "<localleader>rd", ":MoltenDelete<CR>", { silent = true, desc = "molten delete cell" })
-- vim.keymap.set("n", "<localleader>oh", ":MoltenHideOutput<CR>", { silent = true, desc = "hide output" })
-- vim.keymap.set("n", "<localleader>os", ":noautocmd MoltenEnterOutput<CR>", { silent = true, desc = "show/enter output" })
