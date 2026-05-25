return {
	"MeanderingProgrammer/render-markdown.nvim",
	-- in-buffer rendering: headings, tables, code blocks, checkboxes, concealed markup
	dependencies = {
		"nvim-treesitter/nvim-treesitter", -- needs the markdown + markdown_inline parsers
		"nvim-mini/mini.icons", -- icon provider (already in this config)
	},
	ft = { "markdown", "quarto" }, -- load for plain markdown and Quarto / jupyter buffers
	opts = {
		-- render in Quarto docs and .ipynb (which open as quarto), not just plain markdown
		file_types = { "markdown", "quarto" },
		-- show the raw markup on the line the cursor is on, render everywhere else
		anti_conceal = { enabled = true },
	},
}
