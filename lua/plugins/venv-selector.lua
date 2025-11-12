return {
  "linux-cultist/venv-selector.nvim",
  ft = { "python", "jupyter", "ipynb", "qmd", "quarto" }, -- activate for python / jupyter files
  opts = {
    search = {
      globals = {
        command = "fd /bin/python$ ~/.virtualenvs --full-path",
      },
      miniconda = {
        command = "fd /bin/python$ /opt/homebrew/Caskroom/miniconda/base --full-path",
      },
    },
    options = {}, -- if you add plugin options, they go here.
  },
}
