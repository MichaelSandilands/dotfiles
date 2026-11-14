-- SQL / Postgres: connections, query runner, schema browser, completion.
--
-- Requirements: the `psql` client on PATH (Fedora: sudo dnf install postgresql).
--
-- Connections (pick one; keep passwords out of this file):
--   1. Environment variables, e.g. in your shell profile:
--        export DBUI_URL_LOCAL="postgres://michael@localhost:5432/mydb"
--        export DBUI_URL_STAGING="postgres://michael@staging.example.com:5432/app"
--      Each DBUI_URL_<NAME> shows up as a connection called <NAME>.
--   2. :DBUI -> "Add connection" (saved to the dadbod_ui folder in nvim's data dir,
--      in plain text, so avoid putting passwords in the URL).
--   Passwords: use ~/.pgpass (chmod 600) and leave them out of the URL; psql reads it.
return {
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      { "tpope/vim-dadbod", lazy = true },
      { "kristijanhusak/vim-dadbod-completion", lazy = true },
    },
    cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer", "DBUIRenameBuffer", "DBUILastQueryInfo" },
    -- Load for SQL buffers too, so the execute mapping and completion are ready
    ft = { "sql", "mysql", "plsql" },
    keys = {
      { "<leader>du", "<cmd>DBUIToggle<cr>", desc = "Toggle DB UI" },
      { "<leader>df", "<cmd>DBUIFindBuffer<cr>", desc = "Find DB buffer" },
      { "<leader>dr", "<cmd>DBUIRenameBuffer<cr>", desc = "Rename DB buffer" },
      { "<leader>dl", "<cmd>DBUILastQueryInfo<cr>", desc = "Last query info" },
    },
    init = function()
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_save_location = vim.fn.stdpath("data") .. "/dadbod_ui"
      vim.g.db_ui_winwidth = 36
      vim.g.db_ui_show_help = 0
      -- Don't run queries when saving a query buffer. The default (on) would
      -- re-run a DELETE/UPDATE every time you :w.
      vim.g.db_ui_execute_on_save = 0

      -- SQL buffer keymaps
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("dadbod_keymaps", { clear = true }),
        pattern = { "sql", "mysql", "plsql" },
        callback = function(ev)
          -- Normal: run the whole buffer. Visual: run the selection.
          vim.keymap.set({ "n", "v" }, "<leader>de", "<Plug>(DBUI_ExecuteQuery)", {
            buffer = ev.buf, remap = true, desc = "Execute query",
          })
          vim.keymap.set("n", "<leader>dw", "<Plug>(DBUI_SaveQuery)", {
            buffer = ev.buf, remap = true, desc = "Save query",
          })
          vim.keymap.set("n", "<leader>da", "<Plug>(DBUI_EditBindParameters)", {
            buffer = ev.buf, remap = true, desc = "Edit bind parameters",
          })
        end,
      })
    end,
  },
}
