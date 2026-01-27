return {
	"Vigemus/iron.nvim",
	config = function()
		local iron = require("iron.core")
		local view = require("iron.view")
		local common = require("iron.fts.common")

		iron.setup({
			config = {
				repl_definition = {
					sh = { command = { "bash" } },
					python = {
						command = { "ipython", "--no-autoindent" },
						format = common.bracketed_paste_python,
						block_dividers = { "# %%", "#%%", "```" },
						env = { PYTHON_BASIC_REPL = "1" }, --this is needed for python3.13 and up.
					},
					r = {
						command = { "R", "--quiet", "--no-save" },
					},
				},
				repl_open_cmd = view.right("40%"),
			},
			highlight = {},
			ignore_blank_lines = false,
		})
	end,
}
