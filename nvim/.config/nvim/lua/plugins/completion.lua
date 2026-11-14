return {
  {
    "saghen/blink.cmp",
    version = "1.*", -- release tags ship a prebuilt fuzzy-matcher binary
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "rafamadriz/friendly-snippets",
      "milanglacier/minuet-ai.nvim", -- provides the `minuet` source (see minuet.lua)
    },
    ---@module "blink.cmp"
    opts = function()
      return {
        -- 'default': <C-y> accept, <C-n>/<C-p> select, <C-space> open/docs,
        -- <C-e> hide, <C-k> signature help, <Tab>/<S-Tab> snippet jumps.
        keymap = {
          preset = "default",
          -- Ask the local model for a completion on demand
          ["<A-y>"] = require("minuet").make_blink_map(),
        },

        appearance = { nerd_font_variant = "mono" },

        completion = {
          documentation = { auto_show = true, auto_show_delay_ms = 400 },
          trigger = { prefetch_on_insert = false }, -- recommended with minuet
        },

        -- We'll add otter (notebook cells) here later.
        sources = {
          default = { "lsp", "path", "snippets", "buffer", "minuet" },
          -- SQL buffers also get table/column names from the active DBUI connection
          per_filetype = {
            sql = { inherit_defaults = true, "dadbod" },
            mysql = { inherit_defaults = true, "dadbod" },
            plsql = { inherit_defaults = true, "dadbod" },
          },
          providers = {
            dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
            minuet = {
              name = "minuet",
              module = "minuet.blink",
              async = true,
              timeout_ms = 5000, -- match minuet's request_timeout
              score_offset = 50, -- rank AI suggestions higher
            },
          },
        },

        signature = { enabled = true },
      }
    end,
  },
}
