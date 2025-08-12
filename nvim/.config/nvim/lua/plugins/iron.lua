-- lua/plugins/iron.lua

return {
  "Vigemus/iron.nvim",
  -- The `config` function runs after the plugin is loaded.
  config = function()
    local iron = require("iron.core")
    local view = require("iron.view")
    local common = require("iron.fts.common")

    iron.setup({
      config = {

        -- Whether a repl should be discarded or not
        scratch_repl = true,
        -- This is the main configuration table.
        repl_definition = {
          -- For R code blocks (`r`)
          r = {
            -- Uses the 'radian' REPL if available (recommended), otherwise falls back to 'R'.
            command = { "R", "--no-save" },
            format = require("iron.fts.common").bracketed_paste,
          },

          -- For Python code blocks (`python`)
          python = {
            -- Uses IPython for a richer experience.
            command = { "ipython", "--no-autoindent" },
            format = common.bracketed_paste_python,
            block_dividers = { "# %%", "#%%" },
          },
          -- For shell/bash code blocks (`sh`, `bash`)
          sh = {
            command = { "bash" },
          },
          quarto = {
            command = { "R", "--no-save" },
            block_dividers = { "^```" },
          },
          markdown = {
            block_dividers = { "^```" },
          },
        },

        -- How the REPL window opens. This creates a 40-line split at the bottom.
        repl_open_cmd = require("iron.view").bottom(10),

        -- Ignores blank lines when sending code from a visual selection.
        ignore_blank_lines = true,
      },
    })
  end,
}

-- vim: ts=2 sts=2 sw=2 et
