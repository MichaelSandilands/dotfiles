-- ============================================================================
-- neotest keymaps
-- ============================================================================
-- Companion reference: ./neotest-keymaps.md
-- Plugin spec:         ../plugins/neotest.lua
--
-- Loaded from lua/keymaps/keymaps.lua via:
--   require("keymaps.neotest-keymaps")
--
-- Lazy-loading: add `lazy = true` to the neotest spec (see neotest-keymaps.md).
-- Each closure requires "neotest", so it loads on first <leader>t keypress.
--
-- Change vs. original: testing was nested under <leader>dt* (three keystrokes)
-- inside the debug group. It now has its own top-level <leader>t namespace,
-- since testing isn't debugging even when a test launches via DAP.
--
-- Maps marked (new) weren't in the original layout — remove if unwanted.
-- ============================================================================

local wk = require("which-key")

local function neotest()
	return require("neotest")
end

wk.add({
	mode = "n",
	{ "<leader>t", group = "[T]est" },
	{
		"<leader>tt",
		function()
			neotest().run.run()
		end,
		desc = "run nearest [t]est (new)",
	},
	{
		"<leader>tf",
		function()
			neotest().run.run(vim.fn.expand("%"))
		end,
		desc = "run [f]ile",
	},
	{
		"<leader>td",
		function()
			neotest().run.run({ strategy = "dap" })
		end,
		desc = "[d]ebug nearest test",
	},
	{
		"<leader>ts",
		function()
			neotest().run.stop()
		end,
		desc = "[s]top run",
	},
	{
		"<leader>ta",
		function()
			neotest().run.attach()
		end,
		desc = "[a]ttach to test",
	},
	{
		"<leader>to",
		function()
			neotest().output.open()
		end,
		desc = "open [o]utput (new)",
	},
	{
		"<leader>tp",
		function()
			neotest().summary.toggle()
		end,
		desc = "toggle summary [p]anel",
	},
})
