return {
  {
    "benlubas/molten-nvim",
    version = "^1.0.0",
    dependencies = { "3rd/image.nvim" },
    build = ":UpdateRemotePlugins",
    init = function()
      vim.g.molten_auto_open_output = false
      vim.g.molten_image_provider = "image.nvim"
      vim.g.molten_wrap_output = true
      vim.g.molten_virt_text_output = true
      vim.g.molten_virt_lines_off_by_1 = true
      vim.g.molten_output_win_max_height = 20

      -- Kernel setup (optional but recommended)
      vim.g.molten_use_border_highlights = true
      vim.g.molten_auto_image_popup = true
      vim.g.molten_auto_open_html_in_browser = false
    end,

    config = function()
      local keymap = vim.keymap.set
      local opts = { silent = true }

      -- Essential keybindings
      keymap("n", "<localleader>e", ":MoltenEvaluateOperator<CR>", { desc = "evaluate operator", silent = true })
      keymap("n", "<localleader>r", ":noautocmd MoltenEnterOutput<CR>", { desc = "open output window", silent = true })

      -- Additional recommended mappings
      keymap("n", "<localleader>rr", ":MoltenReevaluateCell<CR>", { desc = "re-eval cell", silent = true })
      keymap(
        "v",
        "<localleader>r",
        ":<C-u>MoltenEvaluateVisual<CR>gv",
        { desc = "execute visual selection", silent = true }
      )
      keymap("n", "<localleader>oh", ":MoltenHideOutput<CR>", { desc = "close output window", silent = true })
      keymap("n", "<localleader>md", ":MoltenDelete<CR>", { desc = "delete Molten cell", silent = true })
      keymap("n", "<localleader>mx", ":MoltenOpenInBrowser<CR>", { desc = "open output in browser", silent = true })

      -- Navigation keybindings
      keymap("n", "]c", ":MoltenNextCell<CR>", { desc = "next cell", silent = true })
      keymap("n", "[c", ":MoltenPrevCell<CR>", { desc = "previous cell", silent = true })
      keymap("n", "<localleader>rs", ":MoltenRestartKernel<CR>", { desc = "restart kernel", silent = true })

      -- Auto command to attach molten to Python and ipynb files
      -- vim.api.nvim_create_autocmd("BufEnter", {
      --   pattern = { "*.ipynb", "*.py" },
      --   callback = function()
      --     vim.cmd("MoltenInit")
      --   end,
      -- })

      -- Automatically save output when leaving a buffer (optional)
      -- vim.api.nvim_create_autocmd("BufLeave", {
      --   pattern = { "*.ipynb", "*.py" },
      --   callback = function()
      --     vim.cmd("MoltenSave")
      --   end,
      -- })
    end,
  },
}
