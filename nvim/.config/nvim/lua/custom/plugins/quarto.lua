return {
	-- Plugin #1: quarto-nvim
	{
		"quarto-dev/quarto-nvim",
		ft = { "quarto", "qmd" },
		dependencies = {
			"jmbuhr/otter.nvim",
		},
		opts = {
			lspFeatures = {
				enabled = true,
				languages = { "r", "python", "julia", "bash", "html" },
			},
			codeRunner = {
				enabled = true,
				default_method = "slime",
			},
		},
	},

	-- Plugin #2: vim-slime
	{
		"jpalardy/vim-slime",
		init = function()
			vim.g.slime_target = "neovim"
			vim.g.slime_python_ipython = 1
		end,
	},
}
