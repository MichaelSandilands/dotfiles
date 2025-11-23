return {
  {
    'EdenEast/nightfox.nvim',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    config = function()
      require('nightfox').setup {
        options = {
          transparent = true,
        },
      }

      vim.cmd 'colorscheme carbonfox'
    end,
  },
}
