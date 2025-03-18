-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Keymaps for running Quarto code cells
local runner = require("quarto.runner")
vim.keymap.set("n", "<localleader>rc", runner.run_cell, { desc = "Run cell", silent = true })
vim.keymap.set("n", "<localleader>ra", runner.run_above, { desc = "Run cell and above", silent = true })
vim.keymap.set("n", "<localleader>rA", runner.run_all, { desc = "Run all cells", silent = true })
vim.keymap.set("n", "<localleader>rl", runner.run_line, { desc = "Run line", silent = true })
vim.keymap.set("v", "<localleader>r", runner.run_range, { desc = "Run visual range", silent = true })
vim.keymap.set("n", "<localleader>RA", function()
  runner.run_all(true)
end, { desc = "Run all cells of all languages", silent = true })

-- Keymaps for Molten
vim.keymap.set("n", "<localleader>o", ":MoltenEvaluateOperator<CR>", { desc = "evaluate operator", silent = true })
vim.keymap.set(
  "n",
  "<localleader>r",
  ":noautocmd MoltenEnterOutput<CR>",
  { desc = "open output window", silent = true }
)

vim.keymap.set("n", "<localleader>rr", ":MoltenReevaluateCell<CR>", { desc = "re-eval cell", silent = true })
vim.keymap.set(
  "v",
  "<localleader>r",
  ":<C-u>MoltenEvaluateVisual<CR>gv",
  { desc = "execute visual selection", silent = true }
)
vim.keymap.set("n", "<localleader>oh", ":MoltenHideOutput<CR>", { desc = "close output window", silent = true })
vim.keymap.set("n", "<localleader>md", ":MoltenDelete<CR>", { desc = "delete Molten cell", silent = true })
vim.keymap.set("n", "<localleader>mx", ":MoltenOpenInBrowser<CR>", { desc = "open output in browser", silent = true })

vim.keymap.set("n", "]c", ":MoltenNextCell<CR>", { desc = "next cell", silent = true })
vim.keymap.set("n", "[c", ":MoltenPrevCell<CR>", { desc = "previous cell", silent = true })
vim.keymap.set("n", "<localleader>rs", ":MoltenRestartKernel<CR>", { desc = "restart kernel", silent = true })
