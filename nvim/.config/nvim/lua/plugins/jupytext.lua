return {
	"GCBallesteros/jupytext.nvim",
	opts = {
		custom_language_formatting = {
			python = {
				extension = "qmd",
				style = "pandoc",
				force_ft = "quarto", -- you can set whatever filetype you want here
			},
			r = {
				extension = "qmd",
				style = "pandoc",
				force_ft = "quarto", -- you can set whatever filetype you want here
			},
		},
	},
}
