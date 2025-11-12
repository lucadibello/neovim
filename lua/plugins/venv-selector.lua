return {
  "linux-cultist/venv-selector.nvim",
  ft = { "python", "jupyter", "ipynb" }, -- activate for python / jupyter files
  opts = {
    search = {
      global = {
        command = "fd python$ ~/.venvs",
      },
    },
  },
}
