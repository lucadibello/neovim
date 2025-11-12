return {
  {
    "quarto-dev/quarto-nvim",
    dependencies = {
      "jmbuhr/otter.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    ft = { "quarto", "qmd", "jupyter", "ipynb" },
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

      -- Start Python LSP for code blocks inside Quarto via Otter
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "quarto", "qmd" },
        callback = function()
          local ok, otter = pcall(require, "otter")
          if not ok then
            return
          end
          -- Attach only Python LSP to embedded code chunks
          otter.activate({ "python" }, true, true)
        end,
      })

      vim.api.nvim_create_user_command("QuartoVenvSelect", function()
        require("util.quarto_venv").select()
      end, {})

      vim.keymap.set("n", "<leader>qv", "<cmd>QuartoVenvSelect<CR>", { desc = "Quarto: Select Python venv" })
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
