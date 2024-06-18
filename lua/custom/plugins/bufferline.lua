return {
  'akinsho/bufferline.nvim',
  version = '*',
  dependencies = 'nvim-tree/nvim-web-devicons',
  opts = {
    options = {
      numbers = 'ordinal',
      close_command = 'bdelete! %d',
      right_mouse_command = 'bdelete! %d',
      left_mouse_command = 'buffer %d',
      middle_mouse_command = nil,
      indicator = {
        icon = '▎',
        style = 'icon',
      },
      buffer_close_icon = '',
      modified_icon = '●',
      close_icon = '',
      left_trunc_marker = '',
      right_trunc_marker = '',
      max_name_length = 18,
      max_prefix_length = 15,
      tab_size = 18,
      show_buffer_icons = true,
      show_buffer_close_icons = true,
      show_close_icon = true,
      show_tab_indicators = true,
      persist_buffer_sort = true,
      separator_style = 'thick',
      enforce_regular_tabs = false,
      always_show_bufferline = true,
      diagnostics = 'nvim_lsp',
      sort_by = 'id',
      offsets = {
        {
          filetype = 'neo-tree',
          text = 'File Explorer',
          text_align = 'left',
          separator = true,
        },
      },
    },
  },
  config = function(_, opts)
    -- Pass the settings to
    require('bufferline').setup(opts)

    -- Custom function to return keymap options with description
    local key_opts = function(description)
      return { noremap = true, silent = true, desc = description }
    end

    -- Map Shift+l to move to the buffer on the right
    vim.keymap.set('n', '<S-l>', ':BufferLineCycleNext<CR>', key_opts 'Next Buffer')

    -- Map Shift+h to move to the buffer on the left
    vim.keymap.set('n', '<S-h>', ':BufferLineCyclePrev<CR>', key_opts 'Previous Buffer')

    -- Map keys to close a chosen/current buffer
    vim.keymap.set('n', '<leader>bp', ':BufferLinePickClose<CR>', key_opts 'Pick Close Buffer')

    -- Map keys to move to a specific buffer by ordinal ID
    for i = 1, 9 do
      vim.keymap.set('n', '<leader>b' .. i, ':BufferLineGoToBuffer ' .. i .. '<CR>', key_opts('Buffer ' .. i))
    end

    -- Add mapping to go to the first/last buffer
    vim.keymap.set('n', '<leader>b$', ':BufferLineGoToBuffer -1<CR>', key_opts 'Last buffer')
  end,
}
