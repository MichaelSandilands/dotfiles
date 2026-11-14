-- Leaders must be set before plugins load
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- Python host -----------------------------------------------------------------
-- Dedicated venv for remote plugins (molten needs pynvim + jupyter_client).
-- One-time setup:
--   python3 -m venv ~/.venvs/nvim
--   ~/.venvs/nvim/bin/pip install pynvim jupyter_client ipykernel pyperclip nbformat
--   # a default kernel, so :MoltenInit works anywhere:
--   ~/.venvs/nvim/bin/python -m ipykernel install --user --name python3 --display-name "Python 3 (nvim)"
--   # jupytext CLI (opens/saves .ipynb):
--   uv tool install jupytext        # or: pipx install jupytext
-- Per-project kernel (recommended, so notebooks see the project's packages):
--   .venv/bin/pip install ipykernel && .venv/bin/python -m ipykernel install --user --name myproject
local nvim_venv = vim.fn.expand("~/.venvs/nvim/bin/python")
if vim.uv.fs_stat(nvim_venv) then
  vim.g.python3_host_prog = nvim_venv
end
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0

-- Options ---------------------------------------------------------------------
local o = vim.opt

-- UI
o.number = true
o.relativenumber = true
o.signcolumn = "yes"
o.cursorline = true
o.termguicolors = true
o.showmode = false
o.laststatus = 3 -- global statusline
o.scrolloff = 8
o.sidescrolloff = 8
o.wrap = false
o.breakindent = true
o.list = true
o.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
o.fillchars = { eob = " " }
o.winborder = "rounded" -- 0.11+; harmless on 0.10
o.conceallevel = 2 -- hide markup in markdown/quarto
o.pumheight = 12
o.completeopt = { "menu", "menuone", "noselect" }

-- Behaviour
o.mouse = "a"
o.clipboard = "unnamedplus"
o.undofile = true
o.swapfile = false
o.confirm = true
o.autowrite = true
o.updatetime = 250
o.timeoutlen = 400

-- Search / splits
o.ignorecase = true
o.smartcase = true
o.inccommand = "split"
o.splitright = true
o.splitbelow = true

-- Indent
o.expandtab = true
o.shiftwidth = 4
o.tabstop = 4
o.smartindent = true

-- Folding
o.foldmethod = "expr"
o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
o.foldlevelstart = 99

-- Filetypes -------------------------------------------------------------------
vim.filetype.add({
  extension = {
    qmd = "quarto",
    ipynb = "ipynb",
  },
})
