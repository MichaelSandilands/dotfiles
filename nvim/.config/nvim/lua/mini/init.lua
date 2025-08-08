-- :help mini.basics
require('mini.basics').setup({
	options = {
		extra_ui = true,
	},
	mappings = {
		window = true,
		move_with_alt = true,
	},
})

-- :help mini.ai
require('mini.ai').setup()

-- use `V` to select lines and `gA` to initiate alignment.
-- =<CR> is a very helpful command to align with '=' sign
require('mini.align').setup()

-- <M-k> move line up <M-j> move line down
-- works in visual mode too
require('mini.move').setup()

require('mini.pairs').setup()

-- gS break arguments into new lines or join to single line
require('mini-splitjoin').setup()

-- sa -- Add surrounding in Normal and Visual modes
-- sd -- Delete surrounding
-- sr -- Replace surrounding
require('mini-surround').setup()
