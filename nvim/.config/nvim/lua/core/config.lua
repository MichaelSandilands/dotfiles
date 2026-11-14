-- Autocmds --------------------------------------------------------------------
local group = vim.api.nvim_create_augroup("user_config", { clear = true })

local function autocmd(event, opts)
  opts.group = group
  vim.api.nvim_create_autocmd(event, opts)
end

autocmd("TextYankPost", {
  desc = "Highlight yanked text",
  callback = function() vim.hl.on_yank({ timeout = 150 }) end,
})

autocmd("BufReadPost", {
  desc = "Restore cursor position",
  callback = function(ev)
    local mark = vim.api.nvim_buf_get_mark(ev.buf, '"')
    if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(ev.buf) then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

autocmd("FocusGained", {
  desc = "Reload files changed outside nvim",
  command = "checktime",
})

autocmd("FileType", {
  desc = "SQL: 2-space indent, -- comments",
  pattern = { "sql", "mysql", "plsql" },
  callback = function()
    vim.bo.shiftwidth = 2
    vim.bo.tabstop = 2
    vim.bo.commentstring = "-- %s"
  end,
})

autocmd("FileType", {
  desc = "Prose-ish buffers: soft wrap",
  pattern = { "markdown", "quarto", "text" },
  callback = function()
    vim.wo.wrap = true
    vim.wo.linebreak = true
    vim.bo.shiftwidth = 2
    vim.bo.tabstop = 2
  end,
})

autocmd("FileType", {
  desc = "Close helper windows with q",
  pattern = { "help", "qf", "man", "checkhealth", "lspinfo" },
  callback = function(ev)
    vim.bo[ev.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = ev.buf, silent = true })
  end,
})

-- Diagnostics UI --------------------------------------------------------------
vim.diagnostic.config({
  severity_sort = true,
  update_in_insert = false,
  virtual_text = { spacing = 2, prefix = "●" },
  float = { border = "rounded", source = true },
})

-- lazy.nvim bootstrap ---------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  local out = vim.fn.system({
    "git", "clone", "--filter=blob:none", "--branch=stable",
    "https://github.com/folke/lazy.nvim.git", lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Each file in lua/plugins/ returns a lazy.nvim spec (or list of specs).
-- Planned: telescope, treesitter, lsp (pyright/ruff/sqls), completion,
--          quarto + molten + otter (notebooks), dadbod (SQL), local AI.
require("lazy").setup({
  spec = { { import = "plugins" } },
  install = { colorscheme = { "everforest", "habamax" } },
  checker = { enabled = false },
  change_detection = { notify = false },
  performance = {
    rtp = {
      disabled_plugins = { "gzip", "tarPlugin", "tohtml", "tutor", "zipPlugin" },
    },
  },
})
