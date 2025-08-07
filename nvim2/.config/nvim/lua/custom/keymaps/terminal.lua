-- required in which-key plugin spec in plugins/ui.lua as `require 'config.keymap'`
local wk = require 'which-key'
local ms = vim.lsp.protocol.Methods

local function new_terminal(lang)
  vim.cmd('vsplit term://' .. lang)
end

local function new_terminal_python()
  new_terminal 'python'
end

local function new_terminal_r()
  new_terminal 'R --no-save'
end

local function new_terminal_ipython()
  new_terminal 'ipython --no-confirm-exit --no-autoindent'
end

local function new_terminal_shell()
  new_terminal '$SHELL'
end

local function get_otter_symbols_lang()
  local otterkeeper = require 'otter.keeper'
  local main_nr = vim.api.nvim_get_current_buf()
  local langs = {}
  for i, l in ipairs(otterkeeper.rafts[main_nr].languages) do
    langs[i] = i .. ': ' .. l
  end
  -- promt to choose one of langs
  local i = vim.fn.inputlist(langs)
  local lang = otterkeeper.rafts[main_nr].languages[i]
  local params = {
    textDocument = vim.lsp.util.make_text_document_params(),
    otter = {
      lang = lang,
    },
  }
  -- don't pass a handler, as we want otter to use it's own handlers
  vim.lsp.buf_request(main_nr, ms.textDocument_documentSymbol, params, nil)
end

vim.keymap.set('n', '<leader>os', get_otter_symbols_lang, { desc = 'otter [s]ymbols' })

-- normal mode with <leader>
wk.add({
  { '<leader>c', group = '[c]ode / [c]ell / [c]hunk' },
  { '<leader>ci', new_terminal_ipython, desc = 'new [i]python terminal' },
  { '<leader>cn', new_terminal_shell, desc = '[n]ew terminal with shell' },
  { '<leader>cp', new_terminal_python, desc = 'new [p]ython terminal' },
  { '<leader>cr', new_terminal_r, desc = 'new [R] terminal' },
}, { mode = 'n' })
