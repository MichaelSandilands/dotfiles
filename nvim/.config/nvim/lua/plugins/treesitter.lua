-- nvim-treesitter, `main` branch (the rewrite: no `configs.setup`, parsers are
-- installed with require("nvim-treesitter").install and features are enabled
-- per buffer on FileType).
--
-- Requirements: `git`, a C compiler, and the `tree-sitter` CLI
--   (brew install tree-sitter-cli  |  npm i -g tree-sitter-cli  |  cargo install tree-sitter-cli)
return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false, -- the plugin does not support being lazy-loaded
    build = ":TSUpdate",
    config = function()
      local ts = require("nvim-treesitter")

      -- Quarto files are markdown with fenced code cells; reuse the markdown
      -- parser (and its injections, so ```{python} cells get highlighted).
      vim.treesitter.language.register("markdown", "quarto")

      local parsers = {
        "bash", "diff", "json", "lua", "luadoc", "markdown", "markdown_inline",
        "python", "query", "r", "regex", "sql", "toml", "vim", "vimdoc", "yaml",
        "html", "gitcommit", "git_rebase", "gitignore", "gitattributes",
      }
      ts.install(parsers) -- no-op for parsers that are already installed

      local function attach(buf, lang)
        if not vim.api.nvim_buf_is_valid(buf) then return end
        if not vim.treesitter.language.add(lang) then return end

        vim.treesitter.start(buf, lang) -- highlighting

        -- Treesitter indentation, where the parser ships an indent query
        if vim.treesitter.query.get(lang, "indents") then
          vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end

      local available = ts.get_available()

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("treesitter_attach", { clear = true }),
        callback = function(args)
          local buf = args.buf
          local lang = vim.treesitter.language.get_lang(args.match)
          if not lang then return end

          if vim.tbl_contains(ts.get_installed("parsers"), lang) then
            attach(buf, lang)
          elseif vim.tbl_contains(available, lang) then
            -- Auto-install a missing parser, then enable it for this buffer
            ts.install(lang):await(function() attach(buf, lang) end)
          else
            attach(buf, lang)
          end
        end,
      })
    end,
  },
}
