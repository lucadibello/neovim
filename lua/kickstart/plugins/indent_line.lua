return {
  { -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help ibl`
    main = 'ibl',
    event = 'BufReadPre',
    setup = function()
      vim.g.indent_blankline_char = '│'
      vim.g.indent_blankline_filetype_exclude = { 'help', 'dashboard', 'neotree', 'lazygit' }
      vim.g.indent_blankline_buftype_exclude = { 'terminal' }
      vim.g.indent_blankline_show_trailing_blankline_indent = false
      vim.g.indent_blankline_show_first_indent_level = false
      vim.g.indent_blankline_use_treesitter = true
      vim.g.indent_blankline_show_current_context = true
    end,
  },
}
