return {
  {
    "nvim-telescope/telescope.nvim",
    branch = "master",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "nvim-telescope/telescope-ui-select.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = function() return vim.fn.executable("make") == 1 end,
      },
    },

    -- Lazy-load on first use of any of these keys
    keys = {
      { "<leader><leader>", function() require("telescope.builtin").buffers() end, desc = "Find buffers" },
      { "<leader>sf", function() require("telescope.builtin").find_files() end, desc = "Search files" },
      { "<leader>sg", function() require("telescope.builtin").live_grep() end, desc = "Search by grep" },
      { "<leader>sw", function() require("telescope.builtin").grep_string() end, mode = { "n", "v" }, desc = "Search current word" },
      { "<leader>sh", function() require("telescope.builtin").help_tags() end, desc = "Search help" },
      { "<leader>sk", function() require("telescope.builtin").keymaps() end, desc = "Search keymaps" },
      { "<leader>sd", function() require("telescope.builtin").diagnostics() end, desc = "Search diagnostics" },
      { "<leader>sr", function() require("telescope.builtin").resume() end, desc = "Resume last search" },
      { "<leader>s.", function() require("telescope.builtin").oldfiles() end, desc = "Search recent files" },
      { "<leader>sc", function() require("telescope.builtin").commands() end, desc = "Search commands" },
      { "<leader>ss", function() require("telescope.builtin").builtin() end, desc = "Search Telescope pickers" },
      { "<leader>sC", function() require("telescope.builtin").colorscheme({ enable_preview = true }) end, desc = "Search colorschemes" },
      {
        "<leader>/",
        function()
          require("telescope.builtin").current_buffer_fuzzy_find(
            require("telescope.themes").get_dropdown({ previewer = false })
          )
        end,
        desc = "Fuzzy search in buffer",
      },
      {
        "<leader>s/",
        function()
          require("telescope.builtin").live_grep({
            grep_open_files = true,
            prompt_title = "Live Grep in Open Files",
          })
        end,
        desc = "Grep in open files",
      },
      {
        "<leader>sn",
        function() require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config"), follow = true }) end,
        desc = "Search Neovim config",
      },
    },

    -- Registered at startup so LSP pickers work even before telescope has loaded
    init = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("telescope_lsp_attach", { clear = true }),
        callback = function(ev)
          local function map(lhs, picker, desc)
            vim.keymap.set("n", lhs, function() require("telescope.builtin")[picker]() end, {
              buffer = ev.buf,
              desc = "LSP: " .. desc,
            })
          end
          map("grr", "lsp_references", "References")
          map("gri", "lsp_implementations", "Implementations")
          map("grd", "lsp_definitions", "Definitions")
          map("grt", "lsp_type_definitions", "Type definitions")
          map("gO", "lsp_document_symbols", "Document symbols")
          map("gW", "lsp_dynamic_workspace_symbols", "Workspace symbols")
        end,
      })
    end,

    config = function()
      local actions = require("telescope.actions")

      require("telescope").setup({
        defaults = {
          prompt_prefix = "   ",
          selection_caret = " ",
          sorting_strategy = "ascending",
          layout_config = { prompt_position = "top" },
          file_ignore_patterns = {
            "^%.git/", "node_modules/", "%.venv/", "__pycache__/", "%.ipynb_checkpoints/",
          },
          mappings = {
            i = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
            },
          },
        },
        pickers = {
          find_files = { hidden = true },
        },
        extensions = {
          ["ui-select"] = { require("telescope.themes").get_dropdown() },
        },
      })

      pcall(require("telescope").load_extension, "fzf")
      pcall(require("telescope").load_extension, "ui-select")
    end,
  },
}
