return {
  'nvimdev/dashboard-nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  event = 'VimEnter',
  opts = {
    theme = 'hyper',
    shortcut_type = 'letter',
    config = {}, --  config used for theme
  },
  config = function(_, opts)
    require('dashboard').setup(opts or {})
  end,
}
