-- minuet's `<edit_history>User edited "~/f":…` -> Zeta's `<filename>edit_history` + `--- a/f` diff.
local function zeta_edit_history(rendered)
  local edits = (rendered or ""):gsub("^<edit_history>\n", ""):gsub("\n</edit_history>$", "")
  if edits == "" then
    return ""
  end
  edits = edits:gsub('User edited "([^"]*)":\n\n', function(f)
    f = vim.fn.fnamemodify(vim.fn.expand(f), ":.") -- same naming as <filename>
    return "--- a/" .. f .. "\n+++ b/" .. f .. "\n"
  end)
  return "<filename>edit_history\n" .. edits .. "\n\n"
end

-- Zeta 2.1 prompt format, as in https://huggingface.co/zed-industries/zeta-2.1/raw/main/sample.prompt.
-- Reply: <|marker_1|>{new region}<|marker_2|>; "no change" is <|marker_k|><|marker_k|>.
local ZETA_EOS = "<[end\u{2581}of\u{2581}sentence]>"

-- Ollama's chat API applies a chat template despite `TEMPLATE {{ .Prompt }}`, so Duet
-- needs a pass-through alias. Q4_K_M: same quality as Q5_K_M, faster, 0.8GB smaller.
--   printf '%s\n' 'FROM hf.co/adilkairolla/zeta-2.1-GGUF:Q4_K_M' \
--     'TEMPLATE """{{ if .Messages }}{{ range .Messages }}{{ .Content }}{{ end }}{{ else }}{{ .Prompt }}{{ end }}"""' \
--     > /tmp/Zeta.Modelfile && ollama create zeta-2.1-q4-raw -f /tmp/Zeta.Modelfile
local ZETA_MODEL = "zeta-2.1-q4-raw"

-- Benchmarked on an M2 Pro 16GB: typing p90 ~1.5s, first suggestion at a new spot ~1.5s.
-- Whole lines keep the prompt identical while typing, so Ollama reuses its KV cache.
local ZETA_LINES_BEFORE, ZETA_LINES_AFTER = 20, 8
local ZETA_MAX_HISTORY_CHARS = 600 -- latest edit only, if small

-- ponytail: one slot for the in-flight request's cursor line; minuet kills the previous job first.
local fim_line = { before = "", after = "" }

return {
  {
    "milanglacier/minuet-ai.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },

    -- Load when entering insert mode or opening a buffer, so virtualtext
    -- auto-trigger and duet work without manual intervention.
    event = { "InsertEnter", "BufReadPost" },
    opts = {

      -- ── Inline completions: Zeta 2.1 (Zed's edit-prediction model) ────
      provider = "openai_fim_compatible",
      n_completions = 1,
      context_window = 6000, -- hard cap only; the prompt trims to ZETA_LINES_*
      context_ratio = 0.75, -- 75% prefix, 25% suffix
      request_timeout = 10, -- default 3s times out on local prefill
      after_cursor_filter_length = 15, -- off by default here, but Zeta repeats the next lines

      provider_options = {
        openai_fim_compatible = {
          api_key = "TERM",
          name = "Zeta",
          end_point = "http://localhost:11434/v1/completions",
          model = ZETA_MODEL,
          -- Zeta rewrites the cursor line (the editable region); get_text_fn keeps
          -- only what it added at the cursor, so the reply is parsed whole.
          stream = false,
          template = {
            prompt = function(before, after, opts)
              local b = vim.split(before, "\n", { plain = true })
              local a = vim.split(after, "\n", { plain = true })
              local line_before, line_after = table.remove(b), table.remove(a, 1)
              -- Drop lines cut mid-way by context_window.
              if opts.is_incomplete_before then
                table.remove(b, 1)
              end
              if opts.is_incomplete_after then
                table.remove(a)
              end
              b = vim.list_slice(b, math.max(1, #b - ZETA_LINES_BEFORE + 1))
              a = vim.list_slice(a, 1, ZETA_LINES_AFTER)
              local function lines(t)
                return #t == 0 and "" or table.concat(t, "\n") .. "\n"
              end
              local events = require("minuet.duet.edits").get_events()
              local last = events[#events]
              local history = last and #last.text <= ZETA_MAX_HISTORY_CHARS and zeta_edit_history(last.text) or ""
              fim_line = { before = line_before, after = line_after }
              -- Official layout: empty suffix, the lines after the cursor as a second block.
              return "<[fim-suffix]>\n<[fim-prefix]>"
                .. history
                .. "<filename>"
                .. vim.fn.expand("%:.")
                .. "\n"
                .. lines(b)
                .. "<|marker_1|>"
                .. line_before
                .. "<|user_cursor|>"
                .. line_after
                .. "\n<|marker_2|>"
                .. table.concat(a, "\n")
                .. "<|marker_3|>\n<[fim-middle]>"
            end,
            suffix = false,
          },
          get_text_fn = {
            no_stream = function(json)
              local out = json.choices[1].text:gsub("<|user_cursor|>", "")
              local _, s = out:find("<|marker_1|>", 1, true)
              if not s then
                return ""
              end
              local region = out:sub(s + 1)
              local e = region:find("<|marker_", 1, true)
              if e then
                region = region:sub(1, e - 1)
                if region == "" then -- "no change"
                  return ""
                end
              elseif region:find("\n", #fim_line.before + 1, true) then
                region = region:match("^(.*)\n") -- truncated by max_tokens: complete lines only
              end
              region = region:gsub("\n[ \t]*$", "") -- trailing indent-only line
              -- A rewrite of text before the cursor is not a completion (Duet's job).
              if region:sub(1, #fim_line.before) ~= fim_line.before then
                return ""
              end
              local insert = region:sub(#fim_line.before + 1)
              if fim_line.after ~= "" and insert:sub(-#fim_line.after) == fim_line.after then
                insert = insert:sub(1, -#fim_line.after - 1)
              end
              return insert
            end,
          },
          optional = {
            max_tokens = 48, -- ~30ms/token: caps the worst case near 2s
            temperature = 0,
            stop = { ZETA_EOS, "<|marker_2|>" }, -- only the first block is used
          },
        },
      },

      -- ── Duet: next-edit prediction; Zeta's marker region = Duet's editable region ──
      duet = {
        provider = "openai_compatible",
        request_timeout = 15,
        markers = {
          editable_region_start = "<|marker_1|>",
          editable_region_end = "<|marker_2|>",
          cursor_position = "<|user_cursor|>",
        },
        editable_region = { lines_before = 5, lines_after = 10 }, -- 16 lines: Zeta's max block
        non_editable_region = { context_window = 4000, context_ratio = 0.75 }, -- keeps prefill fast
        provider_options = {
          openai_compatible = {
            api_key = "TERM",
            name = "Zeta",
            end_point = "http://localhost:11434/v1/chat/completions",
            model = ZETA_MODEL,
            few_shots = {},
            chat_input = {
              -- Sections carry their own trailing newline: blank lines for empty ones confuse Zeta.
              template = "<[fim-suffix]>{{{non_editable_region_after}}}<[fim-prefix]>"
                .. "{{{recent_edits}}}<filename>{{{filename}}}\n{{{non_editable_region_before}}}"
                .. "<|marker_1|>{{{editable_region_before_cursor}}}<|user_cursor|>{{{editable_region_after_cursor}}}\n"
                .. "<|marker_2|><[fim-middle]>",
              non_editable_region_before = function(ctx)
                local s = ctx.non_editable_region_before or ""
                return s == "" and "" or s .. "\n"
              end,
              non_editable_region_after = function(ctx)
                local s = ctx.non_editable_region_after or ""
                return s == "" and "" or s .. "\n"
              end,
              filename = function()
                return vim.fn.expand("%:.")
              end,
              recent_edits = function(ctx)
                return zeta_edit_history(ctx.recent_edits)
              end,
            },
            optional = {
              max_tokens = 512,
              temperature = 0,
              -- Doubled markers = "no change": stopping there gives an empty reply, which
              -- Duet ignores instead of warning. (Duet needs <|marker_2|> in the output.)
              stop = { ZETA_EOS, "<|marker_1|><|marker_1|>", "<|marker_2|><|marker_2|>" },
            },
            transform = { -- send only the raw prompt, no system/few-shot messages
              function(d)
                d.body.messages = { d.body.messages[#d.body.messages] }
                return d
              end,
            },
          },
        },
        auto_trigger = {
          auto_trigger_ft = {
            "lua",
            "python",
            "javascript",
            "typescript",
            "typescriptreact",
            "javascriptreact",
            "rust",
            "go",
            "c",
            "cpp",
            "java",
            "ruby",
            "php",
            "html",
            "css",
            "scss",
            "json",
            "yaml",
            "toml",
            "sh",
            "bash",
            "zsh",
            "fish",
            "nix",
            "markdown",
          },
          enable_predicates = {
            function()
              -- Duet prediction fires only in normal mode;
              -- inline FIM completion handles insert mode.
              return vim.fn.mode() == "n"
            end,
          },
        },
      },

      -- ── Virtual text frontend (Copilot-like inline ghost text) ────────
      virtualtext = {
        auto_trigger_ft = { "*" },
        auto_trigger_ignore_ft = {
          -- UI / picker / special buffers
          "snacks_picker_input",
          "TelescopePrompt",
          "Trouble",
          "neo-tree",
          "NvimTree",
          "lazy",
          "mason",
          "help",
          "checkhealth",
          "qf",
          "prompt",
          "noice",
          -- Terminal & REPL
          "toggleterm",
          "terminal",
          -- Git
          "gitcommit",
          "gitrebase",
          "fugitive",
          "DiffviewFiles",
        },
        show_on_completion_menu = true,
        keymap = {
          accept = "<Tab>",
          accept_line = "<A-l>",
          accept_n_lines = "<A-z>",
          prev = "<A-[>",
          next = "<A-]>",
          dismiss = "<A-e>",
        },
      },

      -- ── Throttle / debounce ───────────────────────────────────────────
      throttle = 1000, -- Only fire requests every 1000ms (default)
      debounce = 400, -- Wait 250ms after last keystroke (default 400)

      -- ── Logging ───────────────────────────────────────────────────────
      notify = "debug", -- "debug"/"verbose" also report Zeta's routine "no change" replies
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
      {
        "<leader>ae",
        function()
          require("minuet.duet").action.predict()
        end,
        desc = "Minuet Duet: Predict next edit",
      },
      {
        "<leader>ay",
        function()
          require("minuet.duet").action.apply()
        end,
        desc = "Minuet Duet: Accept edit",
      },
      {
        "<leader>ad",
        function()
          require("minuet.duet").action.dismiss()
        end,
        desc = "Minuet Duet: Dismiss edit",
      },
    },
  },
  {
    "saghen/blink.cmp",
    optional = true,
    enabled = true,
    opts = function(_, opts)
      opts.keymap = opts.keymap or {}
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
