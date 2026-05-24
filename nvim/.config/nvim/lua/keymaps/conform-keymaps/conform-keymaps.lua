-- ============================================================================
-- Conform.nvim keymaps
-- ============================================================================
-- Companion reference: ./conform-keymaps.md
-- Plugin spec:         ../plugins/conform.lua
--
-- Loaded from lua/keymaps/keymaps.lua via:
--   require("keymaps.conform-keymaps")
--
-- Manual format. Format-on-save (if any) is configured in the plugin spec via
-- the BufWritePre event; this is the explicit "format now" map. conform is
-- required lazily, and the spec lazy-loads on BufWritePre / ConformInfo.
-- ============================================================================

local wk = require("which-key")

wk.add({
	mode = { "n", "v" },
	{
		"<leader>=",
		function()
			require("conform").format({ async = true, lsp_format = "fallback" })
		end,
		desc = "Format buffer / selection",
	},
})
