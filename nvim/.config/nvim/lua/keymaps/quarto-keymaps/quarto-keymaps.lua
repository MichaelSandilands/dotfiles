-- ============================================================================
-- Quarto-nvim keymaps
-- ============================================================================
-- Companion reference: ./quarto-keymaps.md
-- Plugin spec:         ../plugins/quarto.lua
--
-- Loaded for its side effects from lua/keymaps/keymaps.lua via:
--   require("keymaps.quarto-keymaps")
--
-- Lazy-loading: quarto-nvim is `ft = { "quarto", "markdown" }` in its spec, so
-- it loads on those filetypes. require("quarto.runner") is deferred into
-- closures so nothing forces it at startup.
--
-- Namespace split:
--   <leader>q   = document / session management (preview, help)  [global-ish]
--   <localleader>q (`,q`) = run code in this buffer (cell runners)
--
-- Note: nabla's `<leader>qm` (toggle math) is defined in nabla's own spec
-- (../plugins/nabla.lua) and will appear in the [Q]uarto group automatically.
-- ============================================================================

local wk = require("which-key")

local function runner()
	return require("quarto.runner")
end

-- ---------------------------------------------------------------------------
-- Document / session management — <leader>q
-- ---------------------------------------------------------------------------
wk.add({
	mode = "n",
	{ "<leader>q", group = "[Q]uarto" },
	{
		"<leader>qp",
		function()
			require("quarto").quartoPreview()
		end,
		desc = "[P]review",
	},
	{
		"<leader>qu",
		function()
			require("quarto").quartoUpdatePreview()
		end,
		desc = "[U]pdate preview",
	},
	{
		"<leader>qq",
		function()
			require("quarto").quartoClosePreview()
		end,
		desc = "[Q]uiet (close) preview",
	},
	{ "<leader>qh", ":QuartoHelp ", desc = "[H]elp (type a topic)" },
})

-- ---------------------------------------------------------------------------
-- Cell runners — <localleader>q  (in-buffer code execution)
-- Capitalization convention: lowercase = scoped, UPPERCASE = "all" variant.
--   qra = run above   |  qrA = run All cells
--   qr* = current language only  |  qR* = All languages
-- ---------------------------------------------------------------------------
wk.add({
	mode = "n",
	{ "<localleader>q", group = "[Q]uarto run" },
	{ "<localleader>qr", group = "[R]un (this language)" },
	{
		"<localleader>qrc",
		function()
			runner().run_cell()
		end,
		desc = "run [C]ell",
		silent = true,
	},
	{
		"<localleader>qra",
		function()
			runner().run_above()
		end,
		desc = "run cell and [A]bove",
		silent = true,
	},
	{
		"<localleader>qrA",
		function()
			runner().run_all()
		end,
		desc = "run [A]ll cells",
		silent = true,
	},
	{
		"<localleader>qrl",
		function()
			runner().run_line()
		end,
		desc = "run [L]ine",
		silent = true,
	},

	{ "<localleader>qR", group = "[R]un (all languages)" },
	{
		"<localleader>qRA",
		function()
			runner().run_all(true)
		end,
		desc = "run [A]ll cells, all languages",
		silent = true,
	},
})

wk.add({
	mode = "v",
	{
		"<localleader>qrr",
		function()
			runner().run_range()
		end,
		desc = "run visual [R]ange",
		silent = true,
	},
})
