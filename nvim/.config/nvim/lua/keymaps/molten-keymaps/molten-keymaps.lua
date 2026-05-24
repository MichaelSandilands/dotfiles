-- ============================================================================
-- Molten-nvim keymaps
-- ============================================================================
-- Companion reference: ./molten-keymaps.md
-- Plugin spec:         ../plugins/molten.lua
--
-- Loaded for its side effects from lua/keymaps/keymaps.lua via:
--   require("keymaps.molten-keymaps")
--
-- Lazy-loading: Molten is intentionally `lazy = false` in its spec — its
-- `init` registers the .ipynb autocmds and vim.g options that must exist
-- before a notebook is opened, and the remote plugin is wired via
-- `:UpdateRemotePlugins`. So these maps use `:Molten*` commands directly;
-- no deferred require is needed.
--
-- Namespace change vs. the original:
--   the env-aware init was on <leader>mp; it's been moved under
--   <localleader>m with the rest of Molten so the whole plugin lives in one
--   namespace (`,m`).
-- ============================================================================

local wk = require("which-key")

-- ---------------------------------------------------------------------------
-- Molten — <localleader>m  (in-buffer kernel execution)
-- ---------------------------------------------------------------------------
wk.add({
	mode = "n",
	{ "<localleader>m", group = "[M]olten" },

	-- Kernel init
	{ "<localleader>mi", "<cmd>MoltenInit<cr>", desc = "[I]nit (pick kernel)" },
	{
		"<localleader>mp",
		function()
			local venv = os.getenv("VIRTUAL_ENV") or os.getenv("CONDA_PREFIX")
			if venv ~= nil then
				-- Extract the env name (e.g. .../envs/ds_stack -> ds_stack)
				venv = string.match(venv, "/.+/(.+)")
				vim.cmd(("MoltenInit %s"):format(venv))
			else
				vim.cmd("MoltenInit python3")
			end
		end,
		desc = "init for active [P]ython env",
	},

	-- Evaluate
	{ "<localleader>me", "<cmd>MoltenEvaluateOperator<cr>", desc = "[E]valuate operator" },
	{ "<localleader>mc", "<cmd>MoltenReevaluateCell<cr>", desc = "reevaluate [C]ell" },

	-- Output
	{ "<localleader>mo", "<cmd>noautocmd MoltenEnterOutput<cr>", desc = "enter/show [O]utput" },
	{ "<localleader>mh", "<cmd>MoltenHideOutput<cr>", desc = "[H]ide output" },

	-- Manage
	{ "<localleader>md", "<cmd>MoltenDelete<cr>", desc = "[D]elete cell" },
})

wk.add({
	mode = "v",
	{ "<localleader>mv", "<cmd>MoltenEvaluateVisual<cr>", desc = "evaluate [V]isual selection" },
})
