local function map(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { desc = desc })
end

map("n", "<Esc>", "<cmd>nohlsearch<cr>", "Clear search highlight")
map({ "n", "i", "v" }, "<C-s>", "<cmd>write<cr><Esc>", "Save file")

-- Windows
map("n", "<C-h>", "<C-w>h", "Go to left window")
map("n", "<C-j>", "<C-w>j", "Go to lower window")
map("n", "<C-k>", "<C-w>k", "Go to upper window")
map("n", "<C-l>", "<C-w>l", "Go to right window")
map("n", "<leader>-", "<C-w>s", "Split below")
map("n", "<leader>|", "<C-w>v", "Split right")

-- Buffers
map("n", "<S-h>", "<cmd>bprevious<cr>", "Previous buffer")
map("n", "<S-l>", "<cmd>bnext<cr>", "Next buffer")
map("n", "<leader>bd", "<cmd>bdelete<cr>", "Delete buffer")

-- Editing
map("v", "<", "<gv", "Indent left, keep selection")
map("v", ">", ">gv", "Indent right, keep selection")
map("n", "<A-j>", "<cmd>m .+1<cr>==", "Move line down")
map("n", "<A-k>", "<cmd>m .-2<cr>==", "Move line up")
map("v", "<A-j>", ":m '>+1<cr>gv=gv", "Move selection down")
map("v", "<A-k>", ":m '<-2<cr>gv=gv", "Move selection up")
map("n", "n", "nzzzv", "Next match (centered)")
map("n", "N", "Nzzzv", "Prev match (centered)")
map("x", "<leader>p", [["_dP]], "Paste without clobbering register")

-- Diagnostics
map("n", "<leader>cd", vim.diagnostic.open_float, "Line diagnostics")
map("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, "Prev diagnostic")
map("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, "Next diagnostic")

-- Terminal
map("t", "<Esc><Esc>", [[<C-\><C-n>]], "Exit terminal mode")
