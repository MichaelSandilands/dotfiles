-- Execute the ./lua/options/options.lua file
require("options.options")

-- Execute the ./lua/config/lazy.lua file
require("config.lazy")

-- Execute the ./lua/keymaps/keymaps.lua file
require("keymaps.keymaps")

-- Execute the ./lua/autocommands/autocommands.lua file
require("autocommands.autocommands")

vim.treesitter.language.register("markdown", "ipynb")
