-- Disable useless jdtls spam (a message on every keypress is a bit too much)
return {
  "mfussenegger/nvim-jdtls",
  opts = {
    -- others
    jdtls = {
      handlers = {
        ["language/status"] = function(_, _) end,
      },
    },
  },
}
