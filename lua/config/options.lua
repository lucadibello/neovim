-- Options are automatically loaded before lazy.nvim startup
--
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.vimtex_view_method = "zathura"
vim.g.latex_view_general_viewer = "zathura"

-- Molten setup
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
