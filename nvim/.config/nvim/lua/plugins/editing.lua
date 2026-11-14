-- General editing quality of life.
return {
  -- Text objects and motions by syntax node ------------------------------------
  --   af / if   around / inside function     ac / ic   around / inside class
  --   aa / ia   around / inside argument
  --   ]f [f     next / previous function     ]k [k     next / previous class
  --   ]F [F     next / previous function end ]K [K     next / previous class end
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    event = "VeryLazy",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("nvim-treesitter-textobjects").setup({
        select = { lookahead = true }, -- jump forward to the next match
        move = { set_jumps = true }, -- moves go in the jumplist (<C-o> goes back)
      })

      local select = require("nvim-treesitter-textobjects.select")
      local move = require("nvim-treesitter-textobjects.move")

      for lhs, capture in pairs({
        af = "@function.outer", ["if"] = "@function.inner",
        ac = "@class.outer", ic = "@class.inner",
        aa = "@parameter.outer", ia = "@parameter.inner",
      }) do
        vim.keymap.set({ "x", "o" }, lhs, function()
          select.select_textobject(capture, "textobjects")
        end, { desc = "Select " .. capture })
      end

      local moves = {
        ["]f"] = { "goto_next_start", "@function.outer" },
        ["[f"] = { "goto_previous_start", "@function.outer" },
        ["]F"] = { "goto_next_end", "@function.outer" },
        ["[F"] = { "goto_previous_end", "@function.outer" },
        ["]k"] = { "goto_next_start", "@class.outer" },
        ["[k"] = { "goto_previous_start", "@class.outer" },
        ["]K"] = { "goto_next_end", "@class.outer" },
        ["[K"] = { "goto_previous_end", "@class.outer" },
      }
      for lhs, spec in pairs(moves) do
        vim.keymap.set({ "n", "x", "o" }, lhs, function()
          move[spec[1]](spec[2], "textobjects")
        end, { desc = spec[1]:gsub("_", " ") .. " " .. spec[2] })
      end
    end,
  },

  -- Brackets and quotes ----------------------------------------------------------
  { "windwp/nvim-autopairs", event = "InsertEnter", opts = { check_ts = true } },

  -- Surround:  saiw)  add ) around word     sd'  delete '     sr)'  replace ) with '
  { "nvim-mini/mini.surround", event = "VeryLazy", opts = {} },

  -- Sticky function/class header at the top while scrolling ---------------------
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = { "BufReadPost", "BufNewFile" },
    opts = { max_lines = 3 },
    keys = {
      { "<leader>tc", "<cmd>TSContext toggle<cr>", desc = "Toggle code context" },
    },
  },

  -- Indent guides (handy in Python, where indentation is structure) --------------
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      indent = { char = "│" },
      scope = { enabled = true, show_start = false, show_end = false },
    },
  },

  -- Diagnostics, references, quickfix in a tidy list -----------------------------
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    opts = {},
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (project)" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Diagnostics (buffer)" },
      { "<leader>xs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Symbols" },
      { "<leader>xl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "LSP definitions / references" },
      { "<leader>xq", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix list" },
      { "<leader>xt", "<cmd>Trouble todo toggle<cr>", desc = "TODO comments" },
    },
  },
}
