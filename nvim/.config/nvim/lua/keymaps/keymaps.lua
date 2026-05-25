-- ============================================================================
-- keymaps.lua — loader + global (non-plugin) maps
-- ============================================================================
-- Plugin-specific keymaps live in their own modules under lua/keymaps/, each
-- with a companion .md reference. This file requires them, then defines the
-- maps that aren't tied to a single plugin.
-- ============================================================================

-- Per-plugin keymap modules ---------------------------------------------------
require("keymaps.telescope-keymaps.telescope-keymaps")
require("keymaps.iron-keymaps.iron-keymaps")
require("keymaps.quarto-keymaps.quarto-keymaps")
require("keymaps.molten-keymaps.molten-keymaps")
require("keymaps.copilot-keymaps.copilot-keymaps")
require("keymaps.conform-keymaps.conform-keymaps")
require("keymaps.dap-keymaps.dap-keymaps")
require("keymaps.neotest-keymaps.neotest-keymaps")
require("keymaps.treesitter-keymaps.treesitter-keymaps")
require("keymaps.render-markdown-keymaps.render-markdown-keymaps")

-- Global maps -----------------------------------------------------------------
local wk = require("which-key")

-- Clear search highlight on <Esc>
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Exit terminal mode with <Esc><Esc>
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Window navigation, resizing, spell toggle
wk.add({
	mode = "n",
	silent = true,
	{ "<c-j>", "<c-w>j" },
	{ "<c-k>", "<c-w>k" },
	{ "<c-h>", "<c-w>h" },
	{ "<c-l>", "<c-w>l" },
	{ "<S-Up>", "<cmd>resize +2<cr>" },
	{ "<S-Down>", "<cmd>resize -2<cr>" },
	{ "<S-Left>", "<cmd>vertical resize -2<cr>" },
	{ "<S-Right>", "<cmd>vertical resize +2<cr>" },
	{ "z?", ":setlocal spell!<cr>", desc = "toggle spellcheck" },
})

-- Code-chunk inserts (markdown / quarto)
-- NOTE: dropped the original `<cm-i>` (invalid modifier notation; it duplicated
-- the Python-chunk action below). Kept `<m-I>` (python) and `<m-i>` (r).
wk.add({
	mode = { "n", "i" },
	silent = true,
	{ "<m-I>", "<esc>i```{python}<cr>```<esc>O", desc = "python code chunk" },
	{ "<m-i>", "<esc>i```{r}<cr>```<esc>O", desc = "r code chunk" },
})

-- which-key group labels
wk.add({
	{ "<C-w>", group = "Window Commands" },
	{ "<C-r>", group = "Paste Register", mode = "i" },
})

-- LSP diagnostics (core vim.diagnostic) + Neogen
-- These are core Neovim, not a plugin, so they live here.
-- Navigation (definition/references/hover/rename/code-action) uses the
-- Neovim 0.11 defaults: grn (rename), gra (code action), grr (references),
-- gri (implementation), K (hover), gO (symbols). Remap below if you want
-- friendlier keys (e.g. gd for definition, which is NOT a default).
wk.add({
	mode = "n",
	{ "<leader>l", group = "[l]anguage/lsp" },
	{ "<leader>ld", group = "[d]iagnostics" },
	{
		"<leader>ldd",
		function()
			vim.diagnostic.enable(false)
		end,
		desc = "[d]isable",
	},
	{
		"<leader>lde",
		function()
			vim.diagnostic.enable(true)
		end,
		desc = "[e]nable",
	},
	{ "<leader>le", vim.diagnostic.open_float, desc = "diagnostics (show hover [e]rror)" },
	{ "<leader>lg", "<cmd>Neogen<cr>", desc = "neo[g]en docstring" },
})
