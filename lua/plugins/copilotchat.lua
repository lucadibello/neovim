-- Configure markdown rendering for Copilot Chat
return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    opts = {
      highlight_headers = false,
      separator = "---",
      error_header = "> [!ERROR] Error",
    },
  },
}
