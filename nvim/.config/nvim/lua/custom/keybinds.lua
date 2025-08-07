local quarto = require 'quarto'
quarto.setup()
vim.keymap.set('n', '<leader>qp', quarto.quartoPreview, { silent = true, noremap = true })

local runner = require 'quarto.runner'
vim.keymap.set('n', '<localleader>rc', runner.run_cell, { desc = 'run cell', silent = true })
vim.keymap.set('n', '<localleader>ra', runner.run_above, { desc = 'run cell and above', silent = true })
vim.keymap.set('n', '<localleader>rA', runner.run_all, { desc = 'run all cells', silent = true })
vim.keymap.set('n', '<localleader>rl', runner.run_line, { desc = 'run line', silent = true })
vim.keymap.set('v', '<localleader>r', runner.run_range, { desc = 'run visual range', silent = true })
vim.keymap.set('n', '<localleader>RA', function()
  runner.run_all(true)
end, { desc = 'run all cells of all languages', silent = true })

-- Open terminals & code repls in a verticle split
vim.keymap.set({ 'n' }, '<leader>ci', ':vsp term://ipython --no-confirm-exit --no-autoindent<cr>', { desc = '[c]ode repl [i]python' })
vim.keymap.set({ 'n' }, '<leader>cp', ':vsp term://python<cr>', { desc = '[c]ode repl [p]ython' })
vim.keymap.set({ 'n' }, '<leader>ct', ':vsp term://$SHELL<cr>', { desc = '[n]ew terminal' })
vim.keymap.set({ 'n' }, '<leader>cr', ':vsp term://R --no-save<cr>', { desc = '[c]ode repl [R]' })

-- Insert quarto & markdown code chunks.
vim.keymap.set({ 'n', 'i' }, '<m-i>', '<esc>i```{r}<cr>```<esc>O', { desc = '[I]nsert r code chunk' })
vim.keymap.set({ 'n' }, '<leader>or', '<esc>i```{r}<cr>```<esc>O', { desc = 'Insert [r] code chunk' })
vim.keymap.set({ 'n', 'i' }, '<m-I>', '<esc>i```{python}<cr>```<esc>O', { desc = '[I]nsert python code chunk' })
vim.keymap.set({ 'n' }, '<leader>op', '<esc>i```{python}<cr>```<esc>O', { desc = 'Insert [p]ython code chunk' })
vim.keymap.set({ 'n' }, '<leader>os', '<esc>i```{sql}<cr>```<esc>O', { desc = 'Insert [s]ql code chunk' })
vim.keymap.set({ 'n' }, '<leader>ob', '<esc>i```{bash}<cr>```<esc>O', { desc = 'Insert [b]ash code chunk' })
