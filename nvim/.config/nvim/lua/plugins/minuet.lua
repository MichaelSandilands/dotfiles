-- Local AI code completion via Ollama, using minuet-ai.nvim.
--
-- Two ways to use it (both enabled):
--   * ghost text  - appears as you type in the filetypes listed below
--   * blink menu  - <A-y> asks Ollama and shows the result in the completion menu
--
-- Setup (once):
--   ollama pull qwen2.5-coder:1.5b      # or :3b / :7b if your hardware is fast enough
--   ollama serve                         # if it isn't already running as a service
--   # keep the model loaded between requests (otherwise the first one is slow):
--   #   OLLAMA_KEEP_ALIVE=1h ollama serve
--
-- Only models trained for fill-in-the-middle (FIM) work well here: qwen2.5-coder,
-- codestral, starcoder2, deepseek-coder... Chat-only models give poor completions.
local model = "qwen2.5-coder:3b"

return {
  {
    "milanglacier/minuet-ai.nvim",
    event = "InsertEnter",
    keys = {
      { "<leader>ta", "<cmd>Minuet virtualtext toggle<cr>", desc = "Toggle AI ghost text" },
    },
    opts = {
      provider = "openai_fim_compatible", -- Ollama's /v1/completions supports FIM
      n_completions = 1, -- one candidate is plenty (and cheaper) for a local model
      context_window = 2048, -- characters around the cursor; lower = faster
      request_timeout = 5, -- seconds
      throttle = 1000, -- ms between requests
      debounce = 400, -- ms to wait after typing stops
      notify = "error",

      provider_options = {
        openai_fim_compatible = {
          name = "Ollama",
          api_key = "TERM", -- Ollama needs no key; this just has to be a set env var
          end_point = "http://localhost:11434/v1/completions",
          model = model,
          optional = {
            max_tokens = 64,
            top_p = 0.9,
          },
        },
      },

      -- Ghost text. Alt-based keys: on macOS, set your terminal's "Option as Meta/Alt".
      virtualtext = {
        auto_trigger_ft = { "python", "sql", "lua", "quarto", "r", "sh" },
        keymap = {
          accept = "<A-a>",
          accept_line = "<A-l>",
          prev = "<A-[>",
          next = "<A-]>",
          dismiss = "<A-e>",
        },
      },

      -- The blink source is manual-only (<A-y>), so the completion menu isn't
      -- slowed down by a model call on every keystroke.
      blink = { enable_auto_complete = false },
    },
  },
}
