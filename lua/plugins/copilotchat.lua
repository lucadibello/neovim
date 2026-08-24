-- Configure markdown rendering for Copilot Chat
return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    enabled = false,
    opts = {
      highlight_headers = false,
      separator = "---",
      error_header = "> [!ERROR] Error",
    },
  },
}
