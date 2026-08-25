return {
  {
    "milanglacier/minuet-ai.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {
      provider = "openai_fim_compatible",
      n_completions = 1, -- Number of completions to request
      context_window = 256,
      provider_options = {
        openai_fim_compatible = {
          api_key = "TERM", -- dummy key for local endpoints
          name = "Ollama",
          end_point = "http://localhost:11434/v1/completions",
          model = "qwen2.5-coder:1.5b",
          optional = {
            max_tokens = 56,
            top_p = 0.9,
          },
        },
      },
      -- Throttling & debounce to keep typing smooth and prevent GPU/CPU saturation
      throttle = 800,
      debounce = 400,

      -- Virtual text frontend (Copilot-like inline ghost text)
      virtualtext = {
        auto_trigger_ft = { "*" }, -- Automatically suggest completions as you type
        auto_trigger_ignore_ft = { "snacks_picker_input", "TelescopePrompt", "Trouble", "neo-tree" },
        keymap = {
          -- Accept the entire completion
          accept = "<A-a>",
          -- Accept completion line by line
          accept_line = "<A-l>",
          -- Accept n lines
          accept_n_lines = "<A-z>",
          -- Cycle through suggestions
          prev = "<A-[>",
          next = "<A-]>",
          -- Dismiss ghost text
          dismiss = "<A-e>",
        },
      },

      -- autocomplete
      cmp = {
        enable_auto_complete = true,
      },
      blink = {
        enable_auto_complete = true,
      },

      -- notify everything for debugging
      notify = "verbose",
    },
    keys = {
      {
        "<leader>am",
        function()
          require("minuet.virtualtext").action.next()
        end,
        mode = { "n", "i" },
        desc = "Minuet: Trigger / Next AI completion",
      },
      {
        "<leader>at",
        function()
          require("minuet.virtualtext").action.toggle_auto_trigger()
        end,
        mode = { "n" },
        desc = "Minuet: Toggle auto-trigger",
      },
    },
  },
  {
    "saghen/blink.cmp",
    optional = true,
    opts = function(_, opts)
      opts.keymap = opts.keymap or {}
      -- Manually invoke minuet completion.
      opts.keymap["<A-y>"] = require("minuet").make_blink_map()

      opts.sources = opts.sources or {}
      opts.sources.default = opts.sources.default or { "lsp", "path", "buffer", "snippets" }
      if type(opts.sources.default) == "table" and not vim.tbl_contains(opts.sources.default, "minuet") then
        table.insert(opts.sources.default, "minuet")
      end

      opts.sources.providers = opts.sources.providers or {}
      opts.sources.providers.minuet = {
        name = "minuet",
        module = "minuet.blink",
        async = true,
        -- Should match minuet.config.request_timeout * 1000,
        -- since minuet.config.request_timeout is in seconds
        timeout_ms = 3000,
        score_offset = 50, -- Gives minuet higher priority among suggestions
      }

      -- Recommended to avoid unnecessary request
      opts.completion = opts.completion or {}
      opts.completion.trigger = opts.completion.trigger or {}
      opts.completion.trigger.prefetch_on_insert = false
    end,
  },
}
