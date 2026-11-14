-- Interactive REPLs in a split: IPython, psql, shell.
-- Send code from any buffer to the REPL of that buffer's filetype.
--
--   <leader>ir  toggle REPL          <leader>il  send line
--   <leader>iR  restart REPL         <leader>iv  send selection (visual)
--   <leader>iF  focus REPL           <leader>ip  send paragraph
--   <leader>ih  hide REPL            <leader>if  send file
--   <leader>ii  interrupt            <leader>iu  send from top to cursor
--   <leader>iq  quit REPL            <leader>is  send motion (e.g. <leader>is3j)
--   <leader>ic  clear REPL           <leader>i<cr>  send Enter
--
-- Python uses `ipython` when it's on PATH, otherwise `python3`. It resolves
-- against the PATH nvim was started with, so launch nvim from inside a
-- project's activated venv (or `uv run nvim`) and the REPL sees that venv's packages.
-- SQL uses `psql` with DATABASE_URL, or else the first DBUI_URL_* variable (see dadbod.lua).
return {
  {
    "Vigemus/iron.nvim",
    event = "VeryLazy",
    keys = {
      { "<leader>iF", "<cmd>IronFocus<cr>", desc = "Focus REPL" },
      { "<leader>ih", "<cmd>IronHide<cr>", desc = "Hide REPL" },
    },
    config = function()
      local common = require("iron.fts.common")
      local format = common.bracketed_paste_python or common.bracketed_paste

      -- Python
      local python_cmd = vim.fn.executable("ipython") == 1
          and { "ipython", "--no-autoindent" }
        or { "python3" }

      -- psql: pick a connection URL from the environment
      local function psql_cmd()
        if vim.env.DATABASE_URL and vim.env.DATABASE_URL ~= "" then
          return { "psql", vim.env.DATABASE_URL }
        end
        local names = {}
        for name in pairs(vim.fn.environ()) do
          if name:match("^DBUI_URL_") then names[#names + 1] = name end
        end
        table.sort(names)
        if #names > 0 then return { "psql", vim.env[names[1]] } end
        return { "psql" } -- falls back to PGHOST / PGUSER / PGDATABASE
      end

      require("iron.core").setup({
        config = {
          scratch_repl = true, -- REPL buffers are throwaway
          repl_definition = {
            python = {
              command = python_cmd,
              format = format,
              block_dividers = { "# %%", "#%%" }, -- cell markers in .py files
            },
            sql = { command = psql_cmd() },
            sh = { command = { vim.o.shell } },
          },
          repl_open_cmd = "vertical botright 80 split",
        },
        keymaps = {
          toggle_repl = "<leader>ir",
          restart_repl = "<leader>iR",
          send_motion = "<leader>is",
          visual_send = "<leader>iv",
          send_file = "<leader>if",
          send_line = "<leader>il",
          send_paragraph = "<leader>ip",
          send_until_cursor = "<leader>iu",
          interrupt = "<leader>ii",
          exit = "<leader>iq",
          clear = "<leader>ic",
          cr = "<leader>i<cr>",
        },
        highlight = { italic = false },
        ignore_blank_lines = true,
      })
    end,
  },
}
