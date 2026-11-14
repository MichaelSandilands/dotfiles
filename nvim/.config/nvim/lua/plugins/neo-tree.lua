return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    cmd = "Neotree",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    keys = {
      { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Toggle file tree" },
      { "<leader>E", "<cmd>Neotree reveal<cr>", desc = "Reveal current file in tree" },
      { "<leader>ge", "<cmd>Neotree git_status float<cr>", desc = "Git status tree" },
    },
    opts = {
      close_if_last_window = true,
      popup_border_style = "rounded",
      sources = { "filesystem", "buffers", "git_status" },
      window = {
        position = "left",
        width = 32,
        mappings = {
          ["<space>"] = "none", -- keep <Space> free (it's the leader)
          ["l"] = "open",
          ["h"] = "close_node",
          ["P"] = { "toggle_preview", config = { use_float = true } },
        },
      },
      filesystem = {
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
        hijack_netrw_behavior = "open_default", -- `nvim .` opens the tree instead of netrw
        filtered_items = {
          visible = true, -- show dotfiles/ignored files, dimmed
          hide_dotfiles = false,
          hide_gitignored = true,
          hide_by_name = { ".git", "__pycache__", ".ipynb_checkpoints", ".DS_Store" },
        },
      },
    },
  },
}
