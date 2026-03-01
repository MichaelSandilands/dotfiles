-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit
-- easier for people to discover. Otherwise, you normally need to press
-- <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own
-- mapping or just use <C-\><C-n> to exit terminal mode
vim.keymap.set({ "t" }, "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- https://github.com/nvim-telescope/telescope.nvim?tab=readme-ov-file#usage
-- See `:help telescope.builtin`
local builtin = require("telescope.builtin")
local wk = require("which-key")

wk.add({
	mode = "n",
	silent = true,
	{ "<c-j>", "<c-w>j" },
	{ "<c-k>", "<c-w>k" },
	{ "<c-h>", "<c-w>h" },
	{ "<c-l>", "<c-w>l" },
	{ "<S-Up>", "<cmd>resize +2<cr>" },
	{ "<S-Down>", "<cmd>resize -2<cr>" },
	{ "<S-Left>", "<cmd>vertical resize -2<cr>" },
	{ "<S-Right>", "<cmd>vertical resize +2<cr>" },
	{ "z?", ":setlocal spell!<cr>", desc = "toggle [z]pellcheck" },
	{ "zl", ":Telescope spell_suggest<cr>", desc = "[l]ist spelling suggestions" },
	{ "<leader>l", group = "[l]anguage/lsp" },
	{ "<leader>ld", group = "[d]iagnostics" },
	{
		"<leader>ldd",
		function()
			vim.diagnostic.enable(false)
		end,
		desc = "[d]isable",
	},
	{ "<leader>lde", vim.diagnostic.enable, desc = "[e]nable" },
	{ "<leader>le", vim.diagnostic.open_float, desc = "diagnostics (show hover [e]rror)" },
	{ "<leader>lg", ":Neogen<cr>", desc = "neo[g]en docstring" },
})

wk.add({
	mode = { "n", "i" },
	silent = true,
	{ "<cm-i>", "<esc>i```{python}<cr>```<esc>O", desc = "python code chunk" },
	{ "<m-I>", "<esc>i```{python}<cr>```<esc>O", desc = "python code chunk" },
	{ "<m-i>", "<esc>i```{r}<cr>```<esc>O", desc = "r code chunk" },
})

wk.add({
	mode = { "n" },
	{ "<leader>f", group = "[F]ind" }, -- group
	{ "<leader>fh", builtin.help_tags, desc = "[F]ind [H]elp" },
	{ "<leader>fk", builtin.keymaps, desc = "[F]ind [K]eymaps" },
	{ "<leader>ff", builtin.find_files, desc = "[F]ind [F]iles" },
	{ "<leader>fs", builtin.builtin, desc = "[F]ind [S]elect Telescope" },
	{ "<leader>fw", builtin.grep_string, desc = "[F]ind current [W]ord" },
	{ "<leader>fg", builtin.live_grep, desc = "[F]ind by [G]rep" },
	{ "<leader>fd", builtin.diagnostics, desc = "[F]ind [D]iagnostics" },
	{ "<leader>fr", builtin.resume, desc = "[F]ind [R]esume" },
	{
		"<leader>f.",
		builtin.oldfiles,
		desc = '[F]ind Recent Files ("." for repeat)',
	},
	{
		"<leader>fb",
		builtin.buffers,
		desc = "[F]ind existing [B]uffers",
	},
	{
		"<leader>/",
		function()
			builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
				winblend = 10,
				previewer = false,
			}))
		end,
		desc = "[/] Fuzzily search in current buffer",
	},
	{
		"<leader>f/",
		function()
			builtin.live_grep({
				grep_open_files = true,
				prompt_title = "Live Grep in Open Files",
			})
		end,
		desc = "[F]ind [/] in Open Files",
	},
	{
		"<leader>fn",
		function()
			builtin.find_files({ cwd = vim.fn.stdpath("config") })
		end,
		desc = "[F]ind [N]eovim files",
	},
})

-- Copilot --
-- I have wrapped these in functions to ensure they don't break if Copilot isn't loaded
wk.add({
	mode = "i", -- Insert Mode Mappings (Ghost Text)
	{
		"<M-l>",
		function()
			require("copilot.suggestion").accept()
		end,
		desc = "Copilot [A]ccept",
	},
	{
		"<M-w>",
		function()
			require("copilot.suggestion").accept_word()
		end,
		desc = "Copilot Accept [W]ord",
	},
	{
		"<M-L>",
		function()
			require("copilot.suggestion").accept_line()
		end,
		desc = "Copilot Accept [L]ine",
	},
	{
		"<M-]>",
		function()
			require("copilot.suggestion").next()
		end,
		desc = "Copilot [N]ext Suggestion",
	},
	{
		"<M-[>",
		function()
			require("copilot.suggestion").prev()
		end,
		desc = "Copilot [P]revious Suggestion",
	},
	{
		"<C-]>",
		function()
			require("copilot.suggestion").dismiss()
		end,
		desc = "Copilot [D]ismiss",
	},
})

-- Conform --
wk.add({
	mode = { "n", "v" },
	{
		"<leader>=",
		function()
			require("conform").format({ async = true, lsp_format = "fallback" })
		end,
		desc = "Format Buffer",
	},
})

-- Quarto --
-- https://github.com/quarto-dev/quarto-nvim?tab=readme-ov-file#running-code
local runner = require("quarto.runner")
wk.add({
	mode = { "n" },
	{ "<localleader>qr", group = "[Q]uarto [R]unners" }, -- group
	{
		"<localleader>qrc",
		runner.run_cell,
		desc = "[Q]uarto [R]un [C]ell",
		silent = true,
	},
	{
		"<localleader>qra",
		runner.run_above,
		desc = "[Q]uarto [R]un cell and [A]bove",
		silent = true,
	},
	{
		"<localleader>qrA",
		runner.run_all,
		desc = "[Q]uarto [R]un [A]ll cells",
		silent = true,
	},
	{
		"<localleader>qrl",
		runner.run_line,
		desc = "[Q]uarto [R]un [L]ine",
		silent = true,
	},
})
wk.add({
	mode = "v",
	{
		"<localleader>qrr",
		runner.run_range,
		desc = "[Q]uarto [R]un visual [R]ange",
		silent = true,
	},
})
wk.add({
	mode = "n",
	{ "<localleader>qR", group = "[Q]uarto [R]un all languages" }, -- group
	{
		"<localleader>qRA",
		function()
			runner.run_all(true)
		end,
		desc = "[Q]uarto [R]un [A]ll cells of [A]ll languages",
		silent = true,
	},
})
wk.add({
	mode = "n",
	{ "<leader>q", group = "[Q]uarto" },
	{ "<leader>qh", ":QuartoHelp ", desc = "[Q]uarto [H]elp" },
	{ "<leader>qp", ":lua require'quarto'.quartoPreview()<cr>", desc = "[Q]uarto [P]review" },
	{ "<leader>qu", ":lua require'quarto'.quartoUpdatePreview()<cr>", desc = "[Q]uarto [U]pdate Preview" },
	{ "<leader>qq", ":lua require'quarto'.quartoClosePreview()<cr>", desc = "[Q]uarto [Q]uiet Preview" },
})

-- Molten --
wk.add({
	mode = "n",
	{ "<localleader>m", group = "[M]olten" },
	{ "<localleader>mi", ":MoltenInit<CR>", desc = "[M]olten [I]nit" },
	{
		"<localleader>me",
		":MoltenEvaluateOperator<CR>",
		desc = "[M]olten [E]valuate Operator",
	},
	{
		"<localleader>mc",
		":MoltenReevaluateCell<CR>",
		desc = "[M]olten Reevaluate [C]ell",
	},
	{
		"<localleader>mo",
		":noautocmd MoltenEnterOutput<CR>",
		desc = "[M]olten enter/show [O]utput",
	},
	{
		"<localleader>mh",
		":MoltenHideOutput<CR>",
		desc = "[M]olten [H]ide Output",
	},
	{
		"<localleader>md",
		":MoltenDelete<CR>",
		desc = "[M]olten [D]elete",
	},
	{
		"<leader>mp",
		function()
			local venv = os.getenv("VIRTUAL_ENV") or os.getenv("CONDA_PREFIX")
			if venv ~= nil then
				-- Extracts the name from the path (e.g., .../envs/ds_stack -> ds_stack)
				venv = string.match(venv, "/.+/(.+)")
				vim.cmd(("MoltenInit %s"):format(venv))
			else
				vim.cmd("MoltenInit python3")
			end
		end,
		desc = "[M]olten [P]ython for active env",
	},
})

wk.add({
	mode = "v",
	{
		"<localleader>mv",
		":MoltenEvaluateVisual<CR>",
		desc = "[M]olten evaluate [V]isual Range",
	},
})

wk.add({
	{ "<C-w>", group = "Window Commands" },
	{ "<C-r>", group = "Paste Register", mode = "i" },
})

-- Iron --
local iron = require("iron.core")
wk.add({
	mode = "n",
	{ "<leader>c", group = "[c]ode" },
	{
		"<leader>cp",
		function()
			iron.repl_for("python")
		end,
		desc = "[C]ode REPL for [P]ython",
	},
	{
		"<leader>cr",
		function()
			iron.repl_for("r")
		end,
		desc = "[C]ode REPL for [R]",
	},
	{
		"<leader>cb",
		function()
			iron.repl_for("sh")
		end,
		desc = "[C]ode REPL for [B]ash",
	},
	{
		"<leader>ct",
		"<cmd>IronRepl<cr>",
		desc = "[C]ode REPL [T]oggle",
	},
	{
		"<leader>cR",
		"<cmd>IronRestart<cr>",
		desc = "[C]ode REPL [R]estart",
	},
	{
		"<leader>cf",
		"<cmd>IronFocus<cr>",
		desc = "[C]ode REPL [F]ocus",
	},
	{
		"<leader>ch",
		"<cmd>IronHide<cr>",
		desc = "[C]ode REPL [H]ide",
	},
	{
		"<leader>cl",
		function()
			iron.send(nil, string.char(12))
		end,
		desc = "[C]ode REPL C[L]ear",
	},
	{
		"<leader>c<cr>",
		function()
			iron.send(nil, string.char(13))
		end,
		desc = "[C]ode REPL [C]arriage [R]eturn",
	},
	{
		"<leader>ci",
		function()
			iron.send(nil, string.char(03))
		end,
		desc = "[C]ode REPL [I]nterrupt",
	},
	{
		"<leader>cq",
		function()
			iron.close_repl()
		end,
		desc = "[C]ode REPL [Q]uit",
	},

	{ "<leader>i", group = "[I]ron" },
	{
		"<leader>ic",
		function()
			iron.run_motion("send_motion")
		end,
		desc = "[I]ron Send Vim [C]ommand",
	},
	{
		"<leader>if",
		function()
			iron.send_file()
		end,
		desc = "[I]ron Send [F]ile",
	},
	{
		"<leader>il",
		function()
			iron.send_line()
		end,
		desc = "[I]ron Send [L]ine",
	},
	{
		"<leader>iu",
		function()
			iron.send_until_cursor()
		end,
		desc = "[I]ron Send [U]ntil Cursor",
	},
	{
		"<leader>ip",
		function()
			iron.send_paragraph()
		end,
		desc = "[I]ron Send [P]aragraph",
	},
	{
		"<leader>ib",
		function()
			iron.send_code_block(false)
		end,
		desc = "[I]ron Send Code [B]lock",
	},
	{
		"<leader>in",
		function()
			iron.send_code_block(true)
		end,
		desc = "[I]ron Send Code [B]lock & Move to [N]ext",
	},
	{
		"<leader>im",
		function()
			iron.run_motion("mark_motion")
		end,
		desc = "[I]ron [M]ark Motion",
	},
	{
		"<leader>id",
		function()
			require("iron.marks").drop_last()
		end,
		desc = "[I]ron [D]elete Last Mark",
	},
})
wk.add({
	mode = "v",
	{ "<leader>iv", iron.visual_send, desc = "[I]ron [V]isual Send" },
	{ "<leader>im", iron.mark_visual, desc = "[I]ron [M]ark Visual" },
	{
		"<leader>il",
		function()
			require("iron.marks").clear_hl()
		end,
		desc = "[I]ron c[L]ear Mark Highlight",
	},
})

-- DAP (Debug) & neotest --
wk.add({
	mode = "n",
	{ "<leader>d", group = "[D]ebug" },
	{ "<leader>dt", group = "[T]esting" },
	{ "<leader>db", ":lua require'dap'.toggle_breakpoint()<cr>", desc = "debug [b]reakpoint" },
	{ "<leader>dc", ":lua require'dap'.continue()<cr>", desc = "debug [c]ontinue" },
	{ "<leader>do", ":lua require'dap'.step_over()<cr>", desc = "debug [o]ver" },
	{ "<leader>dO", ":lua require'dap'.step_out()<cr>", desc = "debug [O]ut" },
	{ "<leader>di", ":lua require'dap'.step_into()<cr>", desc = "debug [i]nto" },
	{ "<leader>dr", ":lua require'dap'.repl.open()<cr>", desc = "debug [r]epl" },
	{ "<leader>du", ":lua require'dapui'.toggle()<cr>", desc = "debug [u]i" },
	{ "<leader>dtt", ":lua require'neotest'.run.run({strategy = 'dap'})<cr>", desc = "[T]est" },
	{ "<leader>dts", ":lua require'neotest'.run.stop()<cr>", desc = "[S]top [T]est" },
	{ "<leader>dta", ":lua require'neotest'.run.attach()<cr>", desc = "[A]ttach [T]est" },
	{ "<leader>dtf", ":lua require'neotest'.run.run(vim.fn.expand('%'))<cr>", desc = "[T]est [f]ile" },
	{ "<leader>dtd", ":lua require'neotest'.summary.toggle()<cr>", desc = "[T]est [D]etails/Summary" },
})

-- Treesitter --
-- https://github.com/nvim-treesitter/nvim-treesitter-textobjects/tree/main?tab=readme-ov-file#text-objects-select
local select = require("nvim-treesitter-textobjects.select").select_textobject
vim.keymap.set({ "x", "o" }, "af", function()
	select("@function.outer", "textobjects")
end, { desc = "[A]round [F]unction" })
vim.keymap.set({ "x", "o" }, "if", function()
	select("@function.inner", "textobjects")
end, { desc = "[I]nner [F]unction" })
vim.keymap.set({ "x", "o" }, "ac", function()
	select("@class.outer", "textobjects")
end, { desc = "[A]round [C]lass" })
vim.keymap.set({ "x", "o" }, "ic", function()
	select("@class.inner", "textobjects")
end, { desc = "[I]nner [C]lass" })
vim.keymap.set({ "x", "o" }, "as", function()
	select("@local.scope", "locals")
end, { desc = "[A]round [S]cope" })
vim.keymap.set({ "x", "o" }, "ib", function()
	select("@code_cell.inner", "textobjects")
end, { desc = "[I]nner code [B]lock" })
vim.keymap.set({ "x", "o" }, "ab", function()
	select("@code_cell.outer", "textobjects")
end, { desc = "[A]round code [B]lock" })
