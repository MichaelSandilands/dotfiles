vim.keymap.set({ 'n', 'i' }, '<m-i>', '<esc>i```{python}<cr>```<esc>O', { desc = '[I]nsert code chunk' })
vim.keymap.set({ 'n' }, '<leader>ci', ':vsplit term://ipython<cr>', { desc = '[C]ode repl [I]python' })
