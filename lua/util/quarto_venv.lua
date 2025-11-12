local M = {}

function M.select()
  local win = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_get_current_buf()

  -- scratch python buffer so a Python LSP attaches
  vim.cmd("enew")
  vim.bo.buftype = "nofile"
  vim.bo.bufhidden = "wipe"
  vim.bo.swapfile = false
  vim.bo.filetype = "python"

  -- give LSP a tick, then run VenvSelect (this autoloads the plugin)
  vim.defer_fn(function()
    -- ensure the plugin is available (optional)
    pcall(require, "venv-selector")
    vim.cmd("VenvSelect")

    -- return to your Quarto buffer
    if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_set_current_win(win)
      vim.api.nvim_set_current_buf(buf)
    end
  end, 80)
end

return M
