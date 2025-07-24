return {
  'aktersnurra/no-clown-fiesta.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    require('no-clown-fiesta').setup {
      transparent = true,
      styles = {
        type = { bold = true },
        lsp = { undercurl = false },
        match_paren = { underline = true },
      },
    }
    require('no-clown-fiesta').load()
  end,
}
