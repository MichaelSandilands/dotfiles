-- Formatting with conform.nvim. Manual only: there is deliberately no
-- format_on_save. Use <leader>cf (buffer or visual selection) or `gq`.
--
-- Formatters are installed by Mason (see `tools` in lsp.lua): stylua, ruff, sqlfluff.
return {
  {
    "stevearc/conform.nvim",
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>cf",
        function() require("conform").format({ async = true }) end,
        mode = { "n", "v" },
        desc = "Format buffer / selection",
      },
    },
    init = function()
      -- Make `gq` use conform too
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
    opts = {
      notify_on_error = true,

      formatters_by_ft = {
        lua = { "stylua" },
        -- Sorts imports, then formats (both from ruff, so one tool + one config)
        python = { "ruff_organize_imports", "ruff_format" },
        sql = { "sqlfluff" },
      },

      formatters = {
        -- sqlfluff must be told the dialect unless the project has a .sqlfluff file.
        -- Swap for { "pg_format" } in formatters_by_ft if you prefer pgFormatter
        -- (needs `sudo dnf install pgFormatter`).
        sqlfluff = {
          args = { "fix", "--dialect=postgres", "-" },
        },
      },

      -- Languages with no formatter listed above fall back to the LSP's formatter
      default_format_opts = { lsp_format = "fallback" },
    },
  },
}
