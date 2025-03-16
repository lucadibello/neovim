return {
  "nvim-lualine/lualine.nvim",
  opts = {
    sections = {
      -- Hide clock component
      lualine_z = {},

      -- Show only the location component
      lualine_y = {
        { "location", padding = { left = 0, right = 1 } },
      },
    },
  },
}
