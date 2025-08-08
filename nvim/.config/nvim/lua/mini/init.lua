-- :help mini.basics
-- :help mini.ai
require('mini.ai').setup()

-- use `V` to select lines and `gA` to initiate alignment.
-- =<CR> is a very helpful command to align with '=' sign
require('mini.align').setup()

require('mini.comment').setup()

require('mini.completion').setup()

require('mini.keymap').setup()

-- <M-k> move line up <M-j> move line down
-- works in visual mode too
require('mini.move').setup()

require('mini.operators').setup()

require('mini.pairs').setup()

local gen_loader = require('mini.snippets').gen_loader
require('mini.snippets').setup({
  snippets = {
    -- Load custom file with global snippets first (adjust for Windows)
    gen_loader.from_file('~/.config/nvim/snippets/global.json'),

    -- Load snippets based on current language by reading files from
    -- "snippets/" subdirectories from 'runtimepath' directories.
    gen_loader.from_lang(),
  },
})


-- gS break arguments into new lines or join to single line
require('mini.splitjoin').setup()

require('mini.surround').setup()

-- sa -- Add surrounding in Normal and Visual modes
-- sd -- Delete surrounding
-- sr -- Replace surrounding
require('mini.basics').setup({
	options = {
		extra_ui = true,
	},
	mappings = {
		window = true,
		move_with_alt = true,
	},
})


local miniclue = require('mini.clue')
miniclue.setup({
  triggers = {
    -- Leader triggers
    { mode = 'n', keys = '<Leader>' },
    { mode = 'x', keys = '<Leader>' },

    -- Built-in completion
    { mode = 'i', keys = '<C-x>' },

    -- `g` key
    { mode = 'n', keys = 'g' },
    { mode = 'x', keys = 'g' },

    -- Marks
    { mode = 'n', keys = "'" },
    { mode = 'n', keys = '`' },
    { mode = 'x', keys = "'" },
    { mode = 'x', keys = '`' },

    -- Registers
    { mode = 'n', keys = '"' },
    { mode = 'x', keys = '"' },
    { mode = 'i', keys = '<C-r>' },
    { mode = 'c', keys = '<C-r>' },

    -- Window commands
    { mode = 'n', keys = '<C-w>' },

    -- `z` key
    { mode = 'n', keys = 'z' },
    { mode = 'x', keys = 'z' },
  },

  clues = {
    -- Enhance this by adding descriptions for <Leader> mapping groups
    miniclue.gen_clues.builtin_completion(),
    miniclue.gen_clues.g(),
    miniclue.gen_clues.marks(),
    miniclue.gen_clues.registers(),
    miniclue.gen_clues.windows(),
    miniclue.gen_clues.z(),
  },

  window = {
	  config = { width = 60},
  }
})
