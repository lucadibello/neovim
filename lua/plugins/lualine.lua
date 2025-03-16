return {
  "nvim-lualine/lualine.nvim",
  opts = {
    options = {
      icons_enabled = true,
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = { "filename" },
      lualine_y = { "location" },
      lualine_z = {},
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { "filename" },
      lualine_x = {},
      lualine_y = {},
      lualine_z = {},
    },
    extensions = {},
  },
}
