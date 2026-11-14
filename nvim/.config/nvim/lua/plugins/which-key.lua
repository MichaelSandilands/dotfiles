return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      preset = "modern",
      delay = 300,
      spec = {
        -- Groups (labels shown in the popup). Some are placeholders for
        -- plugins we haven't added yet.
        { "<leader>s", group = "Search", mode = { "n", "v" } },
        { "<leader>b", group = "Buffer" },
        { "<leader>c", group = "Code" },
        { "<leader>t", group = "Toggle" },
        { "<leader>h", group = "Git hunk", mode = { "n", "v" } },
        { "<leader>g", group = "Git" },
        { "<leader>i", group = "REPL", mode = { "n", "v" } },
        { "<leader>D", group = "Debug", mode = { "n", "v" } },
        { "<leader>T", group = "Test" },
        { "<leader>x", group = "Trouble / diagnostics" },
        { "<leader>a", group = "AI", mode = { "n", "v" } },
        { "<leader>d", group = "Database" },
        { "gr", group = "LSP" },
        { "[", group = "Previous" },
        { "]", group = "Next" },
        -- <localleader> (,) is for notebook/Quarto commands
        { "<localleader>m", group = "Molten (kernel)" },
        { "<localleader>r", group = "Run", mode = { "n", "v" } },
        { "<localleader>o", group = "Output" },
        { "<localleader>q", group = "Quarto" },
      },
    },
    keys = {
      {
        "<leader>?",
        function() require("which-key").show({ global = false }) end,
        desc = "Buffer-local keymaps",
      },
    },
  },
}
