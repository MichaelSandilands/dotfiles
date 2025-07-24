return {
  'danymat/neogen',
  dependencies = 'nvim-treesitter/nvim-treesitter',
  -- Make sure you have DELETED the languages = { ... } table
  config = true,
  keys = {
    {
      '<leader>cd',
      function()
        require('neogen').generate()
      end,
      desc = 'Generate Docstring',
    },
  },
}
