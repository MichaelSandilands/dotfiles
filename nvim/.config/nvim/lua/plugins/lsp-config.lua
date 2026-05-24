return {
	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				-- Load luvit types when the `vim.uv` word is found
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "mason-org/mason.nvim", opts = {} },
			"mason-org/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			"saghen/blink.cmp",
		},
		config = function()
			local capabilities = require("blink.cmp").get_lsp_capabilities()

			local servers = {
				-- Bash
				bashls = {},

				-- Web (HTML, CSS, JSON)
				html = {},
				cssls = {},
				jsonls = {},

				-- Docker
				dockerls = {},

				-- Latex
				texlab = {},

				-- Python
				pyright = {},

				-- R
				r_language_server = {},

				-- Ruff
				ruff = {},

				-- TOML
				taplo = {},

				-- Vim
				vimls = {},

				-- YAML
				yamlls = {},

				-- Lua
				lua_ls = {
					settings = {
						Lua = {
							completion = {
								callSnippet = "Replace",
							},
						},
					},
				},
			}

			local ensure_installed = vim.tbl_keys(servers or {})
			vim.list_extend(ensure_installed, {
				-- Lua
				"stylua",

				-- Python
				"ruff",

				-- Web
				"prettier",
				"prettierd",

				-- Markdown (Linter)
				"markdownlint",
				"jupytext",

				-- Shell / Bash
				"shfmt",
				"shellcheck",

				"tree-sitter-cli",
			})

			require("mason-tool-installer").setup({
				ensure_installed = ensure_installed,
			})

			require("mason-lspconfig").setup({
				ensure_installed = {}, -- installs via mason-tool-installer
				automatic_installation = false,
				handlers = {
					function(server_name)
						local server = servers[server_name] or {}
						server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
						require("lspconfig")[server_name].setup(server)
					end,
				},
			})
		end,
	},
}
