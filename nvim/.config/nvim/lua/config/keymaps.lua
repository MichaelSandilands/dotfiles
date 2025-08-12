-- lua/config/keymaps.lua

vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

local nmap = function(key, effect, desc)
  vim.keymap.set('n', key, effect, { silent = true, noremap = true, desc = desc })
end

local vmap = function(key, effect, desc)
  vim.keymap.set('v', key, effect, { silent = true, noremap = true, desc = desc })
end

local imap = function(key, effect, desc)
  vim.keymap.set('i', key, effect, { silent = true, noremap = true, desc = desc })
end

local cmap = function(key, effect, desc)
  vim.keymap.set('c', key, effect, { silent = true, noremap = true, desc = desc })
end

-- trigger completion in INSERT mode
imap('<c-space>', '<c-x><c-o>', 'Trigger completion')

local wk = require("which-key")

-- File operations

-- Telescope
local builtin = require 'telescope.builtin'
wk.add({
  {
    mode = { "n" }, -- NORMAL mode
    { '<leader>s',  group = '[S]earch' },
    { '<leader>sh', builtin.help_tags,  desc = '[S]earch [H]elp' },
    { '<leader>sk', builtin.keymaps,    desc = '[S]earch [K]eymaps' },
    { '<leader>sf', builtin.find_files, desc = '[S]earch [F]iles' },
    {
      '<leader>sa',
      function()
        builtin.find_files({ hidden = true })
      end,
      desc = '[S]earch [A]ll (Hidden)'
    },
    { '<leader>ss',       builtin.builtin,     desc = '[S]earch [S]elect Telescope' },
    { '<leader>sw',       builtin.grep_string, desc = '[S]earch current [W]ord' },
    { '<leader>sg',       builtin.live_grep,   desc = '[S]earch by [G]rep' },
    { '<leader>sd',       builtin.diagnostics, desc = '[S]earch [D]iagnostics' },
    { '<leader>sr',       builtin.resume,      desc = '[S]earch [R]esume' },
    { '<leader>s.',       builtin.oldfiles,    desc = '[S]earch Recent Files ("." for repeat)' },
    { '<leader><leader>', builtin.buffers,     desc = '[ ] Find existing buffers' },
  }
})

-- Iron
local iron = require("iron.core")
wk.add({
  {
    mode = { "n", "v" },
    { "<leader>r", group = "[R]epl" },
  },
  {
    mode = { "n" },
    -- Keymaps to START or FOCUS a specific REPL
    { "<leader>rr", function() iron.attach("r", 0) end,             desc = "Start [R] REPL" },
    { "<leader>rp", function() iron.attach("python", 0) end,        desc = "Start [P]ython REPL" },
    { "<leader>rs", function() iron.attach("bash", 0) end,          desc = "Start [S]hell REPL" },
    { "<leader>rR", function() iron.repl_restart() end,             desc = "[R]estart current REPL" },
    { "<leader>rx", function() iron.close_repl() end,               desc = "E[x]it current REPL" },
    { "<leader>rh", function() iron.hide_repl() end,                desc = "[H]ide current REPL" },

    -- Keymaps to SEND code to the currently active REPL
    { "<leader>rc", function() iron.send(nil, string.char(12)) end, desc = "[C]lear REPL screen" },
    { "<leader>rl", function() iron.send_line() end,                desc = "Send [L]ine to REPL" },
    { "<leader>rb", function() iron.send_code_block(true) end,      desc = "Send [B]lock to REPL" },
  },
  {
    mode = { "v" },
    { "<leader>rv", function() iron.visual_send() end, desc = "Send [V]isual selection to REPL" },
  }
})

-- vim: ts=2 sts=2 sw=2 et
