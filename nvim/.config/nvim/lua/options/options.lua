-- Line Number Options --
-- Add line numbers
vim.opt.number = true
-- Add relative line numbers
vim.opt.relativenumber = true

-- Screen splitting options --
-- Split below by default when creating horizontal split
vim.opt.splitbelow = true
-- Split right by default when creating vertical split
vim.opt.splitright = true

-- When you meet the end of the screen, text does not jump to a new line
vim.opt.wrap = false

-- Tab Options
-- when `true` tabs become spaces
-- vim.opt.expandtab = true
-- Informs the tabwidth length when saving and opening a file
vim.opt.tabstop = 4
-- set tab width to 4 when using indent
vim.opt.shiftwidth = 4

-- Synchronizes the system clipboard with Neovim's clipboard.
vim.schedule(function()
	vim.o.clipboard = "unnamedplus"
end)

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Sets how neovim will display certain whitespace characters in the editor.
vim.o.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Minimal number of screen lines to keep above and below the cursor.
vim.o.scrolloff = 10

-- Add a vertical bar at 80 characters to the buffer
vim.opt.colorcolumn = "80"

-- Enables "non-character" selection in visual block
vim.opt.virtualedit = "block"

-- Preview changes in a split window when using the `:%s/<find>/<replace>`
vim.opt.inccommand = "split"

-- Ignore case (useful for tab completion, search, etc.)
vim.opt.ignorecase = true
vim.o.smartcase = true

-- Enable full color range
vim.opt.termguicolors = true

-- Setup Diagnostics --

vim.diagnostic.config({
	virtual_lines = true,
})

-- Confirm if you want to close an unsaved file
vim.o.confirm = true

-- Force Neovim's Python provider to use the dedicated nvim_provider environment
vim.g.python3_host_prog = "/home/michael/miniconda3/envs/nvim_provider/bin/python"
