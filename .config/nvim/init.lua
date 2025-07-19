-- Set <space> as the leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed
vim.g.have_nerd_font = true

-- Load core configuration
require('core.options')
require('core.keymaps')
require('core.autocmds')

-- Load plugins
require('core.lazy')
