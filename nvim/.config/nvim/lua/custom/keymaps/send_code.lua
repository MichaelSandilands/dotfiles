local wk = require 'which-key'

vim.g['quarto_is_r_mode'] = nil
vim.g['reticulate_running'] = false

--- Send code to terminal with vim-slime
--- If an R terminal has been opend, this is in r_mode
--- and will handle python code via reticulate when sent
--- from a python chunk.
--- TODO: incorpoarate this into quarto-nvim plugin
--- such that QuartoSend functions get the same capabilities
--- TODO: figure out bracketed paste for reticulate python repl.
local function send_cell()
  local has_molten, molten_status = pcall(require, 'molten.status')
  local molten_works = false
  local molten_active = ''
  if has_molten then
    molten_works, molten_active = pcall(molten_status.kernels)
  end
  if molten_works and molten_active ~= vim.NIL and molten_active ~= '' then
    molten_active = molten_status.initialized()
  end
  if molten_active ~= vim.NIL and molten_active ~= '' and molten_status.kernels() ~= 'Molten' then
    vim.cmd.QuartoSend()
    return
  end

  if vim.b['quarto_is_r_mode'] == nil then
    vim.fn['slime#send_cell']()
    return
  end
  if vim.b['quarto_is_r_mode'] == true then
    vim.g.slime_python_ipython = 0
    local is_python = require('otter.tools.functions').is_otter_language_context 'python'
    if is_python and not vim.b['reticulate_running'] then
      vim.fn['slime#send']('reticulate::repl_python()' .. '\r')
      vim.b['reticulate_running'] = true
    end
    if not is_python and vim.b['reticulate_running'] then
      vim.fn['slime#send']('exit' .. '\r')
      vim.b['reticulate_running'] = false
    end
    vim.fn['slime#send_cell']()
  end
end

--- Send code to terminal with vim-slime
--- If an R terminal has been opend, this is in r_mode
--- and will handle python code via reticulate when sent
--- from a python chunk.
local slime_send_region_cmd = ':<C-u>call slime#send_op(visualmode(), 1)<CR>'
slime_send_region_cmd = vim.api.nvim_replace_termcodes(slime_send_region_cmd, true, false, true)
local function send_region()
  -- if filetyps is not quarto, just send_region
  if vim.bo.filetype ~= 'quarto' or vim.b['quarto_is_r_mode'] == nil then
    vim.cmd('normal' .. slime_send_region_cmd)
    return
  end
  if vim.b['quarto_is_r_mode'] == true then
    vim.g.slime_python_ipython = 0
    local is_python = require('otter.tools.functions').is_otter_language_context 'python'
    if is_python and not vim.b['reticulate_running'] then
      vim.fn['slime#send']('reticulate::repl_python()' .. '\r')
      vim.b['reticulate_running'] = true
    end
    if not is_python and vim.b['reticulate_running'] then
      vim.fn['slime#send']('exit' .. '\r')
      vim.b['reticulate_running'] = false
    end
    vim.cmd('normal' .. slime_send_region_cmd)
  end
end

-- visual mode
wk.add {
  {
    mode = { 'v' },
    { '<cr>', send_region, desc = 'run code region' },
  },
}

-- normal mode with <leader>
wk.add({
  {
    { '<leader><cr>', send_cell, desc = 'run code cell' },
  },
}, { mode = 'n' })
