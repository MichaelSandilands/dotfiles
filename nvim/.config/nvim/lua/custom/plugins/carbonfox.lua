return {
  {
    'EdenEast/nightfox.nvim',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    config = function()
      require('nightfox').setup {}
      vim.cmd 'colorscheme carbonfox'
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
