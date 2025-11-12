return {
  {
    "quarto-dev/quarto-nvim",
    dependencies = {
      "jmbuhr/otter.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    ft = { "quarto", "markdown", "qmd", "jupyter", "ipynb" },
    opts = {
      debug = false,
      closePreviewOnExit = true,
      lspFeatures = {
        enabled = true,
        chunks = "curly",
        languages = { "r", "python", "julia", "bash", "html" },
        diagnostics = {
          enabled = true,
          triggers = { "BufWritePost" },
        },
        completion = {
          enabled = true,
        },
      },
      codeRunner = {
        enabled = true,
        default_method = "molten",
        ft_runners = {
          python = "molten",
        },
        never_run = { "yaml" },
      },
    },
    config = function(_, opts)
      require("quarto").setup(opts)

      -- If you later want Otter to attach a Python LSP inside Quarto blocks, uncomment:
      -- vim.api.nvim_create_autocmd("FileType", {
      --   pattern = { "quarto", "qmd", "jupyter", "ipynb" },
      --   callback = function()
      --     local ok, otter = pcall(require, "otter")
      --     if ok then otter.activate({ "python" }, true, true) end
      --   end,
      -- })
    end,
    keys = function()
      local runner = function(fn)
        return function()
          require("quarto.runner")[fn]()
        end
      end
      return {
        -- run current cell
        { "<localleader>rc", runner("run_cell"), desc = "Run cell", silent = true, mode = "n" },
        -- run current + above
        { "<localleader>ra", runner("run_above"), desc = "Run cell and above", silent = true, mode = "n" },
        -- run all cells (current language)
        { "<localleader>rA", runner("run_all"), desc = "Run all cells", silent = true, mode = "n" },
        -- run current line
        { "<localleader>rl", runner("run_line"), desc = "Run line", silent = true, mode = "n" },
        -- run visual selection/range
        { "<localleader>r", runner("run_range"), desc = "Run visual range", silent = true, mode = "v" },
        -- run all cells of all languages
        {
          "<localleader>RA",
          function()
            require("quarto.runner").run_all(true)
          end,
          desc = "Run all cells (all languages)",
          silent = true,
          mode = "n",
        },
      }
    end,
  },

  -- Ensure Pyright is installed
  {
    "mason-org/mason-lspconfig.nvim",
    opts = function(_, opts)
      opts = opts or {}
      opts.ensure_installed = opts.ensure_installed or {}
      if not vim.tbl_contains(opts.ensure_installed, "pyright") then
        table.insert(opts.ensure_installed, "pyright")
      end
      return opts
    end,
  },
}
