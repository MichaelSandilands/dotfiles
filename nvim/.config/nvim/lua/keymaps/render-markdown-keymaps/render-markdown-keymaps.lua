-- ============================================================================
-- render-markdown.nvim keymaps
-- ============================================================================
-- Companion reference: ./render-markdown-keymaps.md
-- Plugin spec:         ../plugins/render-markdown.lua
--
-- Loaded from lua/keymaps/keymaps.lua via:
--   require("keymaps.render-markdown-keymaps")
--
-- In-buffer rendering toggle + anti-conceal controls. render-markdown is
-- `ft = { "markdown", "quarto" }` in its spec, so the `:RenderMarkdown` command
-- (and these maps) act on markdown / Quarto buffers — that's where the plugin
-- loads. Maps use `<cmd>RenderMarkdown ...<cr>` (same style as Molten).
--
-- Namespace: <leader>m = [m]arkdown render, distinct from Molten's
-- <localleader>m kernel namespace (they don't overlap).
-- ============================================================================

local wk = require("which-key")

wk.add({
	mode = "n",
	{ "<leader>m", group = "[m]arkdown render" },
	{ "<leader>mt", "<cmd>RenderMarkdown toggle<cr>", desc = "[t]oggle render" },
	{ "<leader>me", "<cmd>RenderMarkdown expand<cr>", desc = "[e]xpand raw region" },
	{ "<leader>mc", "<cmd>RenderMarkdown contract<cr>", desc = "[c]ontract raw region" },
})
