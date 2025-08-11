local wk = require("which-key")
local builtin = require 'telescope.builtin'

wk.add({
  {
    mode = { "n" }, -- NORMAL mode
    { '<leader>s', group = '[S]earch' },
    { '<leader>sh', builtin.help_tags, desc = '[S]earch [H]elp' },
    { '<leader>sk', builtin.keymaps, desc = '[S]earch [K]eymaps' },
    { '<leader>sf', builtin.find_files, desc = '[S]earch [F]iles' },
    { '<leader>ss', builtin.builtin, desc = '[S]earch [S]elect Telescope' },
    { '<leader>sw', builtin.grep_string, desc = '[S]earch current [W]ord' },
    { '<leader>sg', builtin.live_grep, desc = '[S]earch by [G]rep' },
    { '<leader>sd', builtin.diagnostics, desc = '[S]earch [D]iagnostics' },
    { '<leader>sr', builtin.resume, desc = '[S]earch [R]esume' },
    { '<leader>s.', builtin.oldfiles, desc = '[S]earch Recent Files ("." for repeat)' },
    { '<leader><leader>', builtin.buffers, desc = '[ ] Find existing buffers' },
  }
})

-- vim: ts=2 sts=2 sw=2 et
