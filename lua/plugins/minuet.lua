return {
  {
    "milanglacier/minuet-ai.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {
      provider = "openai_fim_compatible",
      n_completions = 1, -- Number of completions to request
      context_window = 300, -- ~60 tokens: prompt eval takes ~200ms on CPU
      context_ratio = 0.8, -- 80% before cursor, 20% after cursor
      request_timeout = 3,
      provider_options = {
        openai_fim_compatible = {
          api_key = "TERM", -- dummy key for local endpoints
          name = "Ollama",
          end_point = "http://localhost:11434/v1/completions",
          model = "qwen2.5-coder:1.5b",
          -- Raw FIM template without injecting comments into the small context
          template = {
            prompt = function(pref, _, _)
              return pref
            end,
            suffix = function(_, suff, _)
              return suff
            end,
          },
          optional = {
            max_tokens = 20, -- ~1 line completion (~800ms generation on CPU)
            top_p = 0.9,
          },
        },
      },

      -- Throttling & debounce to keep typing smooth and prevent CPU saturation
      throttle = 800,
      debounce = 400,

      -- Virtual text frontend (Copilot-like inline ghost text)
      virtualtext = {
        auto_trigger_ft = { "*" }, -- Automatically suggest completions as you type
        auto_trigger_ignore_ft = { "snacks_picker_input", "TelescopePrompt", "Trouble", "neo-tree" },
        show_on_completion_menu = true, -- Keep Copilot-like ghost text visible even when blink menu is open
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

      -- autocomplete (use virtualtext as primary frontend; keep menu completion manual)
      cmp = {
        enable_auto_complete = false,
      },
      blink = {
        enable_auto_complete = false,
      },

      -- notify warnings and errors only
      notify = "warn",
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
      -- Manually invoke minuet completion in blink menu if needed via <A-y>
      opts.keymap["<A-y>"] = require("minuet").make_blink_map()

      opts.sources = opts.sources or {}
      opts.sources.providers = opts.sources.providers or {}
      opts.sources.providers.minuet = {
        name = "minuet",
        module = "minuet.blink",
        async = true,
        timeout_ms = 3000,
        score_offset = 50,
      }

      opts.completion = opts.completion or {}
      opts.completion.trigger = opts.completion.trigger or {}
      opts.completion.trigger.prefetch_on_insert = false
    end,
  },
}
