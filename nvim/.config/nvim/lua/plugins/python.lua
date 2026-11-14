-- Python workflow: docstrings, virtualenvs, tests.
return {
  -- Docstrings ----------------------------------------------------------------
  -- <leader>cn on a def/class inserts a docstring skeleton, then Tab / Shift-Tab
  -- jump between the fields.
  --
  -- Style: PEP 257 layout (one-line summary, blank line, description) with
  -- PEP 287 reStructuredText fields (:param x:, :returns:, :raises:). PEP 257
  -- doesn't define section markup itself; PEP 287 is the PEP-endorsed markup.
  -- To lint docstrings to PEP 257, add this to a project's pyproject.toml:
  --   [tool.ruff.lint]
  --   extend-select = ["D"]
  --   [tool.ruff.lint.pydocstyle]
  --   convention = "pep257"
  {
    "danymat/neogen",
    cmd = "Neogen",
    keys = {
      { "<leader>cn", function() require("neogen").generate() end, desc = "Generate docstring" },
    },
    opts = {
      snippet_engine = "nvim", -- built-in vim.snippet (Tab jumps via blink.cmp)
      languages = {
        python = { template = { annotation_convention = "reST" } },
      },
    },
  },

  -- Virtualenvs ----------------------------------------------------------------
  -- <leader>cv: pick a venv from a Telescope list. The plugin points basedpyright
  -- (and dap-python) at it and restarts the LSP.
  {
    "linux-cultist/venv-selector.nvim",
    branch = "main",
    ft = "python",
    cmd = "VenvSelect",
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-telescope/telescope.nvim",
      "mfussenegger/nvim-dap-python",
    },
    keys = {
      { "<leader>cv", "<cmd>VenvSelect<cr>", desc = "Select virtualenv" },
    },
    opts = {},
  },

  -- Tests ----------------------------------------------------------------------
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/neotest-python",
    },
    keys = {
      { "<leader>Tn", function() require("neotest").run.run() end, desc = "Run nearest test" },
      { "<leader>Tf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run file" },
      { "<leader>Ta", function() require("neotest").run.run(vim.uv.cwd()) end, desc = "Run all tests" },
      { "<leader>Tl", function() require("neotest").run.run_last() end, desc = "Run last" },
      { "<leader>Td", function() require("neotest").run.run({ strategy = "dap" }) end, desc = "Debug nearest test" },
      { "<leader>Tx", function() require("neotest").run.stop() end, desc = "Stop test run" },
      { "<leader>Ts", function() require("neotest").summary.toggle() end, desc = "Toggle summary" },
      { "<leader>To", function() require("neotest").output.open({ enter = true }) end, desc = "Show output" },
      { "<leader>TO", function() require("neotest").output_panel.toggle() end, desc = "Toggle output panel" },
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-python")({
            runner = "pytest",
            dap = { justMyCode = false }, -- <leader>Td can step into libraries
          }),
        },
      })
    end,
  },
}
