-- plugins/quarto.lua
return {
  {
    'quarto-dev/quarto-nvim',
    opts = {},
    dependencies = {
      'jmbuhr/otter.nvim',
      opts = {
        buffers = {
          write_to_disk = true,
        },
      },
      'nvim-treesitter/nvim-treesitter',
    },
  },
}
