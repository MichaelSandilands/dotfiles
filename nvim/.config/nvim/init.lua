-- ~/.config/nvim/init.lua
-- Neovim config for SQL, Python, Quarto, Jupyter, local AI, Telescope.
-- Requires Neovim >= 0.10 (0.11+ recommended).

if vim.fn.has("nvim-0.10") == 0 then
  vim.api.nvim_echo({ { "This config requires Neovim >= 0.10", "ErrorMsg" } }, true, {})
  return
end

require("core.options") -- leaders, options, python host, filetypes
require("core.keymaps") -- global keymaps
require("core.config") -- autocmds, diagnostics, lazy.nvim (loads lua/plugins/*)
