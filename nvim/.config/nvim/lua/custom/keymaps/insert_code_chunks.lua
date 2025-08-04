-- required in which-key plugin spec in plugins/ui.lua as `require 'config.keymap'`
local wk = require 'which-key'

---Is the current context a code chunk?
---@param lang string language of the code chunk
---@return boolean
local is_code_chunk = function(lang)
  local current = require('otter.keeper').get_current_language_context()
  if current == lang then
    return true
  else
    return false
  end
end

--- Insert code chunk of given language
--- Splits current chunk if already within a chunk
--- @param lang string
--- @param curly boolean
local insert_a_code_chunk = function(lang, curly)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<esc>', true, false, true), 'n', true)
  local keys
  if curly == nil then
    curly = true
  end
  if is_code_chunk(lang) then
    if curly then
      keys = [[o```<cr><cr>```{]] .. lang .. [[}<esc>o]]
    else
      keys = [[o```<cr><cr>```]] .. lang .. [[<esc>o]]
    end
  else
    if curly then
      keys = [[o```{]] .. lang .. [[}<cr>```<esc>O]]
    else
      keys = [[o```]] .. lang .. [[<cr>```<esc>O]]
    end
  end
  keys = vim.api.nvim_replace_termcodes(keys, true, false, true)
  vim.api.nvim_feedkeys(keys, 'n', false)
end

local insert_code_chunk = function(lang)
  insert_a_code_chunk(lang, true)
end

local insert_plain_code_chunk = function(lang)
  insert_a_code_chunk(lang, false)
end

local insert_r_chunk = function()
  insert_code_chunk 'r'
end

local insert_py_chunk = function()
  insert_code_chunk 'python'
end

local insert_lua_chunk = function()
  insert_code_chunk 'lua'
end

local insert_julia_chunk = function()
  insert_code_chunk 'julia'
end

local insert_bash_chunk = function()
  insert_code_chunk 'bash'
end

local insert_ojs_chunk = function()
  insert_code_chunk 'ojs'
end

local insert_plain_r_chunk = function()
  insert_plain_code_chunk 'r'
end

local insert_plain_py_chunk = function()
  insert_plain_code_chunk 'python'
end

local insert_plain_lua_chunk = function()
  insert_plain_code_chunk 'lua'
end

local insert_plain_julia_chunk = function()
  insert_plain_code_chunk 'julia'
end

local insert_plain_bash_chunk = function()
  insert_plain_code_chunk 'bash'
end

local insert_plain_ojs_chunk = function()
  insert_plain_code_chunk 'ojs'
end

--show kepbindings with whichkey
--add your own here if you want them to
--show up in the popup as well

-- normal mode
wk.add({
  { '<cm-i>', insert_py_chunk, desc = 'python code chunk' },
  { '<m-I>', insert_py_chunk, desc = 'python code chunk' },
  { '<m-i>', insert_r_chunk, desc = 'r code chunk' },
}, { mode = 'n', silent = true })

-- insert mode
wk.add({
  {
    mode = { 'i' },
    { '<cm-i>', insert_py_chunk, desc = 'python code chunk' },
    { '<m-->', ' <- ', desc = 'assign' },
    { '<m-I>', insert_py_chunk, desc = 'python code chunk' },
    { '<m-i>', insert_r_chunk, desc = 'r code chunk' },
    { '<m-m>', ' |>', desc = 'pipe' },
  },
}, { mode = 'i' })

-- normal mode with <leader>
wk.add({
  {
    { '<leader>o', group = '[o]tter & c[o]de' },
    { '<leader>oa', require('otter').activate, desc = 'otter [a]ctivate' },
    { '<leader>oc', 'O# %%<cr>', desc = 'magic [c]omment code chunk # %%' },
    { '<leader>od', require('otter').activate, desc = 'otter [d]eactivate' },

    { '<leader>oj', insert_julia_chunk, desc = '[j]ulia code chunk' },
    { '<leader>ol', insert_lua_chunk, desc = '[l]lua code chunk' },
    { '<leader>oo', insert_ojs_chunk, desc = '[o]bservable js code chunk' },
    { '<leader>op', insert_py_chunk, desc = '[p]ython code chunk' },
    { '<leader>or', insert_r_chunk, desc = '[r] code chunk' },
    { '<leader>ob', insert_bash_chunk, desc = '[b]ash code chunk' },

    { '<leader>Oj', insert_plain_julia_chunk, desc = '[j]ulia code chunk' },
    { '<leader>Ol', insert_plain_lua_chunk, desc = '[l]lua code chunk' },
    { '<leader>Oo', insert_plain_ojs_chunk, desc = '[o]bservable js code chunk' },
    { '<leader>Op', insert_plain_py_chunk, desc = '[p]ython code chunk' },
    { '<leader>Or', insert_plain_r_chunk, desc = '[r] code chunk' },
    { '<leader>Ob', insert_plain_bash_chunk, desc = '[b]ash code chunk' },
  },
}, { mode = 'n' })
