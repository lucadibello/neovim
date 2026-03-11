-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Ensure neovim Python virtualenv exists with required dependencies
local python_env = require("util.python_env")
local venv_status = python_env.ensure_venv()
vim.g.python3_host_prog = python_env.get_python_path()

-- If the venv was just created, run UpdateRemotePlugins after startup and prompt to restart
if venv_status == "created" then
  vim.api.nvim_create_autocmd("VimEnter", {
    once = true,
    callback = function()
      vim.cmd("UpdateRemotePlugins")
      vim.notify(
        "Python environment ready. Please restart Neovim to load remote plugins.",
        vim.log.levels.WARN
      )
    end,
  })
end

-- If no prettier config file is found, the formatter will not be used
vim.g.lazyvim_prettier_needs_config = false
