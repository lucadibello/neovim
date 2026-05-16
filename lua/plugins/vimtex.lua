return {
  {
    "lervag/vimtex",
    lazy = false,
    init = function()
      -- override default viewer to use sioyek
      vim.g.vimtex_view_method = "sioyek"
    end,
  },
}
