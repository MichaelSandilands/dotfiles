-- ============================================================================
-- Copilot.lua keymaps
-- ============================================================================
-- Companion reference: ./copilot-keymaps.md
-- Plugin spec:         ../plugins/copilot.lua
--
-- Loaded from lua/keymaps/keymaps.lua via:
--   require("keymaps.copilot-keymaps")
--
-- These are insert-mode ghost-text controls. copilot.suggestion is required
-- lazily inside each closure, and the spec already lazy-loads on InsertEnter,
-- so nothing forces Copilot at startup.
-- ============================================================================

local wk = require("which-key")

wk.add({
	mode = "i",
	{
		"<M-l>",
		function()
			require("copilot.suggestion").accept()
		end,
		desc = "Copilot [a]ccept",
	},
	{
		"<M-w>",
		function()
			require("copilot.suggestion").accept_word()
		end,
		desc = "Copilot accept [w]ord",
	},
	{
		"<M-L>",
		function()
			require("copilot.suggestion").accept_line()
		end,
		desc = "Copilot accept [l]ine",
	},
	{
		"<M-]>",
		function()
			require("copilot.suggestion").next()
		end,
		desc = "Copilot [n]ext suggestion",
	},
	{
		"<M-[>",
		function()
			require("copilot.suggestion").prev()
		end,
		desc = "Copilot [p]revious suggestion",
	},
	{
		"<C-]>",
		function()
			require("copilot.suggestion").dismiss()
		end,
		desc = "Copilot [d]ismiss",
	},
})
