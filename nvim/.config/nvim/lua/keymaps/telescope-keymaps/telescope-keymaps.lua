-- ============================================================================
-- Telescope keymaps
-- ============================================================================
-- Companion reference: ./telescope-keymaps.md
-- Plugin spec:         ../plugins/telescope.lua
--
-- Loaded for its side effects from lua/keymaps/keymaps.lua via:
--   require("keymaps.telescope-keymaps")
--
-- Note: telescope.builtin is required lazily inside each closure (via the
-- `builtin()` helper) rather than at module scope. This keeps telescope
-- lazy-loaded — it only loads the first time one of these keys is pressed,
-- instead of eagerly at startup.
-- ============================================================================

local wk = require("which-key")

-- Deferred accessor: telescope only loads when a mapping actually fires.
local function builtin()
	return require("telescope.builtin")
end

wk.add({
	mode = "n",
	{ "<leader>f", group = "[F]ind" },
	{
		"<leader>fh",
		function()
			builtin().help_tags()
		end,
		desc = "[F]ind [H]elp",
	},
	{
		"<leader>fk",
		function()
			builtin().keymaps()
		end,
		desc = "[F]ind [K]eymaps",
	},
	{
		"<leader>ff",
		function()
			builtin().find_files()
		end,
		desc = "[F]ind [F]iles",
	},
	{
		"<leader>fs",
		function()
			builtin().builtin()
		end,
		desc = "[F]ind [S]elect Telescope",
	},
	{
		"<leader>fw",
		function()
			builtin().grep_string()
		end,
		desc = "[F]ind current [W]ord",
	},
	{
		"<leader>fg",
		function()
			builtin().live_grep()
		end,
		desc = "[F]ind by [G]rep",
	},
	{
		"<leader>fd",
		function()
			builtin().diagnostics()
		end,
		desc = "[F]ind [D]iagnostics",
	},
	{
		"<leader>fr",
		function()
			builtin().resume()
		end,
		desc = "[F]ind [R]esume",
	},
	{
		"<leader>f.",
		function()
			builtin().oldfiles()
		end,
		desc = '[F]ind Recent Files ("." for repeat)',
	},
	{
		"<leader>fb",
		function()
			builtin().buffers()
		end,
		desc = "[F]ind existing [B]uffers",
	},
	{
		"<leader>/",
		function()
			builtin().current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
				winblend = 10,
				previewer = false,
			}))
		end,
		desc = "[/] Fuzzily search in current buffer",
	},
	{
		"<leader>f/",
		function()
			builtin().live_grep({
				grep_open_files = true,
				prompt_title = "Live Grep in Open Files",
			})
		end,
		desc = "[F]ind [/] in Open Files",
	},
	{
		"<leader>fn",
		function()
			builtin().find_files({ cwd = vim.fn.stdpath("config") })
		end,
		desc = "[F]ind [N]eovim files",
	},
	-- Telescope-backed spell suggestions (moved here from the global keymaps).
	{ "zl", "<cmd>Telescope spell_suggest<cr>", desc = "[l]ist spelling suggestions" },
})
