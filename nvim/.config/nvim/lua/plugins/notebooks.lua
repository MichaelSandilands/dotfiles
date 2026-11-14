-- Notebook stack: Quarto + Jupyter.
--
--   quarto-nvim   .qmd support, cell running, preview
--   otter.nvim    LSP/completion/diagnostics for code inside cells (used by quarto-nvim)
--   molten-nvim   runs code against a Jupyter kernel, shows output inline
--   jupytext.nvim opens .ipynb files as plain text (.qmd) and saves back to .ipynb
--
-- External requirements (see the setup notes in core/options.lua):
--   * the nvim venv with pynvim + jupyter_client + ipykernel
--   * at least one registered Jupyter kernel   (jupyter kernelspec list)
--   * `jupytext` on PATH                       (uv tool install jupytext)
--   * `quarto` CLI, for :QuartoPreview         (https://quarto.org/docs/get-started/)
return {
  -- Kernel runner ------------------------------------------------------------
  {
    "benlubas/molten-nvim",
    version = "^1.0.0",
    build = ":UpdateRemotePlugins", -- restart nvim once after the first install
    lazy = false, -- remote plugins need to be registered at startup
    init = function()
      vim.g.molten_image_provider = "none" -- switch to "image.nvim" in a kitty-protocol terminal
      vim.g.molten_virt_text_output = true -- show output as virtual text under the cell
      vim.g.molten_virt_lines_off_by_1 = true -- keeps output below the closing ``` of a cell
      vim.g.molten_auto_open_output = false
      vim.g.molten_wrap_output = true
      vim.g.molten_output_win_max_height = 20
      vim.g.molten_use_border_highlights = true

      -- Keymaps (python + quarto buffers)
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("molten_keymaps", { clear = true }),
        pattern = { "python", "quarto" },
        callback = function(ev)
          local function map(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = ev.buf, silent = true, desc = desc })
          end
          -- Kernel lifecycle
          map("n", "<localleader>mi", "<cmd>MoltenInit<cr>", "Start kernel")
          map("n", "<localleader>mq", "<cmd>MoltenDeinit<cr>", "Stop kernel")
          map("n", "<localleader>mx", "<cmd>MoltenInterrupt<cr>", "Interrupt kernel")
          map("n", "<localleader>mR", "<cmd>MoltenRestart!<cr>", "Restart kernel")
          -- Evaluate (python buffers; quarto buffers use <localleader>r* above)
          if vim.bo[ev.buf].filetype == "python" then
            map("n", "<localleader>rl", "<cmd>MoltenEvaluateLine<cr>", "Run line")
            map("v", "<localleader>r", ":<C-u>MoltenEvaluateVisual<cr>gv", "Run selection")
          end
          map("n", "<localleader>re", "<cmd>MoltenEvaluateOperator<cr>", "Run (operator)")
          map("n", "<localleader>rR", "<cmd>MoltenReevaluateCell<cr>", "Re-run cell")
          -- Output
          map("n", "<localleader>os", "<cmd>MoltenShowOutput<cr>", "Show output")
          map("n", "<localleader>oh", "<cmd>MoltenHideOutput<cr>", "Hide output")
          map("n", "<localleader>oe", "<cmd>noautocmd MoltenEnterOutput<cr>", "Enter output window")
          map("n", "<localleader>md", "<cmd>MoltenDelete<cr>", "Delete cell output")
          -- Navigate cells
          map("n", "]b", "<cmd>MoltenNext<cr>", "Next cell")
          map("n", "[b", "<cmd>MoltenPrev<cr>", "Previous cell")
        end,
      })
    end,
  },

  -- Quarto + LSP inside cells --------------------------------------------------
  {
    "quarto-dev/quarto-nvim",
    ft = { "quarto" },
    dependencies = {
      "jmbuhr/otter.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      lspFeatures = {
        enabled = true,
        chunks = "curly", -- only treat ```{python} style chunks as code
        languages = { "python", "r", "sql", "bash", "lua" },
        diagnostics = { enabled = true, triggers = { "BufWritePost" } },
        completion = { enabled = true },
      },
      codeRunner = {
        enabled = true,
        default_method = "molten",
      },
    },
    config = function(_, opts)
      require("quarto").setup(opts)

      -- Quarto-only keymaps (cell-aware runner)
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("quarto_keymaps", { clear = true }),
        pattern = "quarto",
        callback = function(ev)
          local runner = require("quarto.runner")
          local function map(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = ev.buf, desc = desc })
          end
          map("n", "<localleader>rc", runner.run_cell, "Run cell")
          map("n", "<localleader>ra", runner.run_above, "Run cell and above")
          map("n", "<localleader>rA", runner.run_all, "Run all cells")
          map("n", "<localleader>rl", runner.run_line, "Run line")
          map("v", "<localleader>r", runner.run_range, "Run selection")
          map("n", "<localleader>qp", "<cmd>QuartoPreview<cr>", "Quarto preview")
          map("n", "<localleader>qc", "<cmd>QuartoClosePreview<cr>", "Close Quarto preview")
        end,
      })
    end,
  },

  -- .ipynb <-> text ----------------------------------------------------------
  {
    "GCBallesteros/jupytext.nvim",
    lazy = false, -- needs to hook BufReadCmd for *.ipynb at startup
    opts = {
      -- Non-Python notebooks: plain markdown
      style = "markdown",
      output_extension = "md",
      force_ft = "markdown",
      -- Python notebooks open as Quarto documents, so the Quarto/otter/molten
      -- setup above applies to them.
      custom_language_formatting = {
        python = {
          extension = "qmd",
          style = "quarto",
          force_ft = "quarto",
        },
      },
    },
  },
}
