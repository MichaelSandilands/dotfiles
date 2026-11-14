-- Version control:
--   gitsigns   gutter signs, hunk staging/preview, blame      (<leader>h*, ]h / [h)
--   neogit     a magit-style interface: status, commit, push  (<leader>gg)
--   diffview   side-by-side diffs and file/repo history       (<leader>gd, <leader>gh)
--   telescope  git pickers: files, status, branches, commits  (<leader>g*)
return {
  -- Hunks in the buffer ----------------------------------------------------------
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "┃" },
        change = { text = "┃" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
        untracked = { text = "┆" },
      },
      current_line_blame_opts = { delay = 500 },
      on_attach = function(bufnr)
        local gs = require("gitsigns")
        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end

        -- Navigation (falls back to the built-in jumps when diffing)
        map("n", "]h", function()
          if vim.wo.diff then vim.cmd.normal({ "]c", bang = true }) else gs.nav_hunk("next") end
        end, "Next hunk")
        map("n", "[h", function()
          if vim.wo.diff then vim.cmd.normal({ "[c", bang = true }) else gs.nav_hunk("prev") end
        end, "Previous hunk")

        -- Stage / reset
        map("n", "<leader>hs", gs.stage_hunk, "Stage hunk")
        map("n", "<leader>hr", gs.reset_hunk, "Reset hunk")
        map("v", "<leader>hs", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "Stage selection")
        map("v", "<leader>hr", function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "Reset selection")
        map("n", "<leader>hS", gs.stage_buffer, "Stage buffer")
        map("n", "<leader>hR", gs.reset_buffer, "Reset buffer")

        -- Inspect
        map("n", "<leader>hp", gs.preview_hunk, "Preview hunk")
        map("n", "<leader>hi", gs.preview_hunk_inline, "Preview hunk inline")
        map("n", "<leader>hb", function() gs.blame_line({ full = true }) end, "Blame line")
        map("n", "<leader>hd", gs.diffthis, "Diff against index")
        map("n", "<leader>hD", function() gs.diffthis("~") end, "Diff against last commit")
        map("n", "<leader>hq", gs.setqflist, "Hunks in file to quickfix")
        map("n", "<leader>hQ", function() gs.setqflist("all") end, "Hunks in repo to quickfix")

        -- Toggles
        map("n", "<leader>tb", gs.toggle_current_line_blame, "Toggle line blame")
        map("n", "<leader>tw", gs.toggle_word_diff, "Toggle word diff")

        -- Text object: `vih`, `dih`, ...
        map({ "o", "x" }, "ih", gs.select_hunk, "Inside hunk")
      end,
    },
  },

  -- Git UI ------------------------------------------------------------------------
  {
    "NeogitOrg/neogit",
    cmd = "Neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "nvim-telescope/telescope.nvim",
    },
    keys = {
      { "<leader>gg", "<cmd>Neogit<cr>", desc = "Neogit status" },
      { "<leader>gp", "<cmd>Neogit pull<cr>", desc = "Pull" },
      { "<leader>gP", "<cmd>Neogit push<cr>", desc = "Push" },
      { "<leader>gl", "<cmd>Neogit log<cr>", desc = "Log" },
    },
    opts = {
      graph_style = "unicode",
      integrations = { diffview = true, telescope = true },
    },
  },

  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory", "DiffviewToggleFiles" },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diff working tree" },
      { "<leader>gD", "<cmd>DiffviewClose<cr>", desc = "Close diff view" },
      { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "File history" },
      { "<leader>gH", "<cmd>DiffviewFileHistory<cr>", desc = "Repo history" },
    },
    opts = {},
  },

  -- Telescope git pickers (merged into the spec in telescope.lua) ------------------
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      { "<leader>gf", function() require("telescope.builtin").git_files() end, desc = "Git files" },
      { "<leader>gs", function() require("telescope.builtin").git_status() end, desc = "Git status (picker)" },
      { "<leader>gb", function() require("telescope.builtin").git_branches() end, desc = "Git branches" },
      { "<leader>gc", function() require("telescope.builtin").git_commits() end, desc = "Git commits" },
      { "<leader>gC", function() require("telescope.builtin").git_bcommits() end, desc = "Commits for this file" },
    },
  },
}
