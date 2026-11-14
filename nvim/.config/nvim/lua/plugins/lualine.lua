return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = function()
      -- Everforest theme with a transparent middle section, to match the
      -- transparent background.
      local theme = require("lualine.themes.everforest")
      for _, mode in pairs(theme) do
        if mode.c then
          mode.c.bg = "NONE"
        end
      end

      -- Active LSP clients for the current buffer
      local function lsp_clients()
        local names = {}
        for _, c in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
          names[#names + 1] = c.name
        end
        return #names > 0 and (" " .. table.concat(names, ",")) or ""
      end

      -- Active Python virtualenv / conda env
      local function python_env()
        if vim.bo.filetype ~= "python" and vim.bo.filetype ~= "quarto" then
          return ""
        end
        local venv = vim.env.VIRTUAL_ENV or vim.env.CONDA_PREFIX
        return venv and (" " .. vim.fn.fnamemodify(venv, ":t")) or ""
      end

      return {
        options = {
          theme = theme,
          globalstatus = true, -- pairs with laststatus = 3
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          disabled_filetypes = { statusline = { "lazy", "alpha", "dashboard" } },
        },
        sections = {
          lualine_a = { { "mode", fmt = function(s) return s:sub(1, 1) end } },
          lualine_b = {
            { "branch", icon = "" },
            {
              "diff",
              symbols = { added = " ", modified = " ", removed = " " },
            },
          },
          lualine_c = {
            { "filename", path = 1, symbols = { modified = " ●", readonly = " ", unnamed = "[No Name]" } },
            {
              "diagnostics",
              symbols = { error = " ", warn = " ", info = " ", hint = " " },
            },
          },
          lualine_x = {
            { python_env, color = { fg = "#a7c080" } },
            { lsp_clients },
            { "filetype", icon_only = false },
          },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
        extensions = { "lazy", "quickfix", "man", "neo-tree" },
      }
    end,
  },
}
