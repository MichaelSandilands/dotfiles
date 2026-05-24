-- ============================================================================
-- nvim-dap keymaps
-- ============================================================================
-- Companion reference: ./dap-keymaps.md
-- Plugin spec:         ../plugins/nvim-dap.lua
--
-- Loaded from lua/keymaps/keymaps.lua via:
--   require("keymaps.dap-keymaps")
--
-- Lazy-loading: add `lazy = true` to the nvim-dap spec (see dap-keymaps.md).
-- Each closure requires "dap"/"dapui", so dap loads on first debug keypress.
--
-- Change vs. original: the neotest maps that lived under <leader>dt* have moved
-- to their own <leader>t namespace (see neotest-keymaps.lua). This file is
-- DAP-only now.
--
-- Capitalization convention: lowercase = step into the smaller scope,
-- UPPERCASE = step "out/further".  do = step Over, dO = step Out.
-- ============================================================================

local wk = require("which-key")

wk.add({
	mode = "n",
	{ "<leader>d", group = "[D]ebug" },
	{
		"<leader>db",
		function()
			require("dap").toggle_breakpoint()
		end,
		desc = "[b]reakpoint toggle",
	},
	{
		"<leader>dc",
		function()
			require("dap").continue()
		end,
		desc = "[c]ontinue",
	},
	{
		"<leader>do",
		function()
			require("dap").step_over()
		end,
		desc = "step [o]ver",
	},
	{
		"<leader>dO",
		function()
			require("dap").step_out()
		end,
		desc = "step [O]ut",
	},
	{
		"<leader>di",
		function()
			require("dap").step_into()
		end,
		desc = "step [i]nto",
	},
	{
		"<leader>dr",
		function()
			require("dap").repl.open()
		end,
		desc = "open [r]epl",
	},
	{
		"<leader>du",
		function()
			require("dap") -- ensure dap config (dapui listeners) is loaded
			require("dapui").toggle()
		end,
		desc = "toggle [u]i",
	},
})
