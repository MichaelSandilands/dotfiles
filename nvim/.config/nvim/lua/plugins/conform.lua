return {
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					python = { "ruff_format" },
					quarto = { "injected" },
					markdown = { "injected" },
					r = { "styler" },
					javascript = {
						"prettierd",
						"prettier",
						stop_after_first = true,
					},
					typescript = {
						"prettierd",
						"prettier",
						stop_after_first = true,
					},
					yaml = { "prettierd", "prettier", stop_after_first = true },
					json = { "prettierd", "prettier", stop_after_first = true },
					jsonc = { "prettierd", "prettier", stop_after_first = true },
					toml = { "taplo" },

					-- Shell / Pipelines
					sh = { "shfmt" },
					bash = { "shfmt" },
				},
			})
			-- Customize the "injected" formatter
			require("conform").formatters.injected = {
				-- Set the options field
				options = {
					-- Set to true to ignore errors
					ignore_errors = false,
					-- Map of treesitter language to file extension
					-- A temporary file name with this extension will be
					-- generated during formatting because some formatters care
					-- about the filename.
					lang_to_ext = {
						bash = "sh",
						c_sharp = "cs",
						elixir = "exs",
						javascript = "js",
						julia = "jl",
						latex = "tex",
						markdown = "md",
						python = "py",
						ruby = "rb",
						rust = "rs",
						teal = "tl",
						r = "r",
						typescript = "ts",

						-- Add these for injected blocks (e.g., SQL inside Python strings):
						sql = "sql",
						json = "json",
						yaml = "yaml",
					},
					-- Map of treesitter language to formatters to use
					-- -- (defaults to the value from formatters_by_ft)
					lang_to_formatters = {},
				},
			}
		end,
	},
}
