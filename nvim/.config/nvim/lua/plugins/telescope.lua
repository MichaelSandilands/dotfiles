return {
	{ 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
	{'nvim-telescope/telescope-ui-select.nvim' },
	{
    'nvim-telescope/telescope.nvim',
      dependencies = { 'nvim-lua/plenary.nvim' },
      config = function ()
require('telescope').setup {
extensions = {
    ["ui-select"] = {
      require("telescope.themes").get_dropdown {
        -- even more opts
      }
      }
      }
      }
require('telescope').load_extension('fzf')
require("telescope").load_extension("ui-select")
	end,
}
    }

-- vim: ts=2 sts=2 sw=2 et
