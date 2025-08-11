vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.g.have_nerd_font = true

require("core.lazy")
require("lsp")
require("config.keymaps")

-- vim: ts=2 sts=2 sw=2 et
