-- ============================================================================
-- nvim-treesitter-textobjects keymaps
-- ============================================================================
-- Companion reference: ./treesitter-keymaps.md
-- Plugin spec:         ../plugins/treesitter.lua
--
-- Loaded from lua/keymaps/keymaps.lua via:
--   require("keymaps.treesitter-keymaps")
--
-- These are operator-pending / visual textobject selections (the de-facto
-- standard af/if/ac/ic set). They use plain vim.keymap.set rather than
-- which-key, since they're motions, not leader maps. The select function is
-- required lazily; treesitter itself is lazy=false (highlighting is wanted
-- everywhere), so textobjects loads alongside it.
-- ============================================================================

-- Deferred accessor for the select API.
local function select(obj, query)
	return require("nvim-treesitter-textobjects.select").select_textobject(obj, query)
end

local map = function(lhs, obj, query, desc)
	vim.keymap.set({ "x", "o" }, lhs, function()
		select(obj, query)
	end, { desc = desc })
end

map("af", "@function.outer", "textobjects", "[a]round [f]unction")
map("if", "@function.inner", "textobjects", "[i]nner [f]unction")
map("ac", "@class.outer", "textobjects", "[a]round [c]lass")
map("ic", "@class.inner", "textobjects", "[i]nner [c]lass")
map("as", "@local.scope", "locals", "[a]round [s]cope")
map("ib", "@code_cell.inner", "textobjects", "[i]nner code [b]lock")
map("ab", "@code_cell.outer", "textobjects", "[a]round code [b]lock")
