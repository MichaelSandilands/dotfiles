-- ============================================================================
-- Iron.nvim keymaps
-- ============================================================================
-- Companion reference: ./iron-keymaps.md
-- Plugin spec:         ../plugins/iron.lua
--
-- Loaded for its side effects from lua/keymaps/keymaps.lua via:
--   require("keymaps.iron-keymaps")
--
-- Lazy-loading: iron.core is required lazily inside each closure (via the
-- `iron()` helper), and the command-string maps (toggle/restart/focus/hide)
-- are covered by `cmd = {...}` in the plugin spec. Iron therefore only loads
-- the first time one of these keys is pressed.
--
-- Layout changes vs. the original monolithic keymaps.lua:
--   * restart moved <leader>cR -> <leader>cs   (removes the cr/cR fat-finger
--     trap: cr = "REPL for R", cR previously = "restart")
--   * clear-mark-highlight moved (visual) <leader>il -> <leader>ih, and is now
--     bound in both normal and visual (removes the il mode-split: il was
--     "send line" in normal but "clear highlight" in visual)
-- ============================================================================

local wk = require("which-key")

-- Deferred accessors: iron only loads when a mapping actually fires.
local function iron()
	return require("iron.core")
end
local function marks()
	return require("iron.marks")
end

-- ---------------------------------------------------------------------------
-- REPL control: open a REPL, manage the running session
-- ---------------------------------------------------------------------------
wk.add({
	mode = "n",
	{ "<leader>c", group = "[c]ode REPL" },

	-- Open a REPL by language
	{
		"<leader>cp",
		function()
			iron().repl_for("python")
		end,
		desc = "REPL for [p]ython",
	},
	{
		"<leader>cr",
		function()
			iron().repl_for("r")
		end,
		desc = "REPL for [r] (R)",
	},
	{
		"<leader>cb",
		function()
			iron().repl_for("sh")
		end,
		desc = "REPL for [b]ash",
	},

	-- Manage the running REPL
	{ "<leader>ct", "<cmd>IronRepl<cr>", desc = "REPL [t]oggle" },
	{ "<leader>cf", "<cmd>IronFocus<cr>", desc = "REPL [f]ocus" },
	{ "<leader>ch", "<cmd>IronHide<cr>", desc = "REPL [h]ide" },
	{ "<leader>cs", "<cmd>IronRestart<cr>", desc = "REPL re[s]tart" },
	{
		"<leader>cq",
		function()
			iron().close_repl()
		end,
		desc = "REPL [q]uit",
	},

	-- Send control signals to the REPL process
	{
		"<leader>cl",
		function()
			iron().send(nil, string.char(12))
		end,
		desc = "REPL c[l]ear (C-l)",
	},
	{
		"<leader>ci",
		function()
			iron().send(nil, string.char(03))
		end,
		desc = "REPL [i]nterrupt (C-c)",
	},
	{
		"<leader>c<cr>",
		function()
			iron().send(nil, string.char(13))
		end,
		desc = "REPL carriage [return]",
	},
})

-- ---------------------------------------------------------------------------
-- Send code to the REPL (normal mode)
-- ---------------------------------------------------------------------------
wk.add({
	mode = "n",
	{ "<leader>i", group = "[i]ron send" },
	{
		"<leader>ic",
		function()
			iron().run_motion("send_motion")
		end,
		desc = "send vim [c]ommand/motion",
	},
	{
		"<leader>if",
		function()
			iron().send_file()
		end,
		desc = "send [f]ile",
	},
	{
		"<leader>il",
		function()
			iron().send_line()
		end,
		desc = "send [l]ine",
	},
	{
		"<leader>iu",
		function()
			iron().send_until_cursor()
		end,
		desc = "send [u]ntil cursor",
	},
	{
		"<leader>ip",
		function()
			iron().send_paragraph()
		end,
		desc = "send [p]aragraph",
	},
	{
		"<leader>ib",
		function()
			iron().send_code_block(false)
		end,
		desc = "send code [b]lock",
	},
	{
		"<leader>in",
		function()
			iron().send_code_block(true)
		end,
		desc = "send code block & [n]ext",
	},
	{
		"<leader>im",
		function()
			iron().run_motion("mark_motion")
		end,
		desc = "[m]ark motion",
	},
	{
		"<leader>id",
		function()
			marks().drop_last()
		end,
		desc = "[d]rop last mark",
	},
})

-- ---------------------------------------------------------------------------
-- Send code to the REPL (visual mode)
-- ---------------------------------------------------------------------------
wk.add({
	mode = "v",
	{
		"<leader>iv",
		function()
			iron().visual_send()
		end,
		desc = "[v]isual send",
	},
	{
		"<leader>im",
		function()
			iron().mark_visual()
		end,
		desc = "[m]ark visual",
	},
})

-- ---------------------------------------------------------------------------
-- Clear mark highlight (both modes — replaces the old visual-only <leader>il)
-- ---------------------------------------------------------------------------
wk.add({
	mode = { "n", "v" },
	{
		"<leader>ih",
		function()
			marks().clear_hl()
		end,
		desc = "clear mark [h]ighlight",
	},
})
