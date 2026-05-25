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

-- Custom picker: list every unique #a/b/c tag in the project, then drill into
-- the chosen one with grep_string. Tags are pulled with ripgrep (run without a
-- shell, so the regex needs no escaping), then uniqued + sorted in Lua. All
-- telescope modules are required lazily inside here to keep startup clean.
local function tag_picker()
	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local conf = require("telescope.config").values
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")

	-- #<letter> then word/slash chars, e.g. #pandas/wrangling. Excludes spaced
	-- comments (`# note`), shebangs (`#!`), and divider lines (`####`).
	local matches = vim.fn.systemlist({
		"rg",
		"--no-filename",
		"--no-line-number",
		"--only-matching",
		"--no-config",
		"#[A-Za-z][A-Za-z0-9_/]*",
	})

	local seen, tags = {}, {}
	for _, tag in ipairs(matches) do
		if not seen[tag] then
			seen[tag] = true
			table.insert(tags, tag)
		end
	end
	table.sort(tags)

	if vim.tbl_isempty(tags) then
		vim.notify("No #tags found in the project", vim.log.levels.INFO)
		return
	end

	pickers
		.new({}, {
			prompt_title = "Tags (" .. #tags .. ")",
			finder = finders.new_table({ results = tags }),
			sorter = conf.generic_sorter({}),
			attach_mappings = function(prompt_bufnr)
				actions.select_default:replace(function()
					local entry = action_state.get_selected_entry()
					actions.close(prompt_bufnr)
					if entry then
						-- jump among every occurrence of the chosen tag (literal match)
						builtin().grep_string({ search = entry[1], use_regex = false })
					end
				end)
				return true
			end,
		})
		:find()
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
		"<leader>f#",
		function()
			-- seed the prompt with "#": type a category (e.g. numpy/) to get
			-- "#numpy/" and narrow live across .py / .qmd / .ipynb
			builtin().live_grep({ default_text = "#", prompt_title = "Find #tags (live)" })
		end,
		desc = "[F]ind [#]tags (live grep)",
	},
	{
		"<leader>ft",
		tag_picker,
		desc = "[F]ind [T]ag (unique list)",
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
