return {
  'EdenEast/nightfox.nvim',
  priority = 1000, -- make sure to load this before all the other start plugins
  config = function()
    require('nightfox').setup {
      transparent = true,
    }
    -- Enable theme
    vim.cmd.colorscheme 'carbonfox'
  end,
}
