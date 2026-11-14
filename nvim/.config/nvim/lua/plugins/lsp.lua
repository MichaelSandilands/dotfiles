return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "mason-org/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      { "j-hui/fidget.nvim", opts = {} }, -- LSP progress in the corner
      "saghen/blink.cmp", -- provides completion capabilities
    },
    config = function()
      -- Servers --------------------------------------------------------------
      -- Keys are nvim-lspconfig names; values are passed to vim.lsp.config().
      -- Everything here is installed by Mason automatically.
      local servers = {
        -- Python: types/navigation from basedpyright, lint/format from ruff
        basedpyright = {
          settings = {
            basedpyright = {
              disableOrganizeImports = true, -- ruff handles import sorting
              analysis = {
                typeCheckingMode = "standard",
                diagnosticMode = "openFilesOnly",
              },
            },
          },
        },
        ruff = {},

        -- SQL. Postgres server works without config but is much more useful with a
        -- postgrestools.jsonc in the project root (db connection). Swap for `sqls`
        -- or similar if you use another dialect.
        postgres_lsp = {},

        -- Markdown, including Quarto prose
        marksman = {
          filetypes = { "markdown", "markdown.mdx", "quarto" },
        },

        lua_ls = {
          settings = {
            Lua = {
              runtime = { version = "LuaJIT" },
              workspace = {
                checkThirdParty = false,
                library = { vim.env.VIMRUNTIME },
              },
              diagnostics = { globals = { "vim" } },
              format = { enable = false }, -- stylua does formatting
              telemetry = { enable = false },
            },
          },
        },
      }

      -- Non-LSP tools Mason should install too
      local tools = { "stylua", "sqlfluff", "debugpy" }

      -- Mason ---------------------------------------------------------------
      -- automatic_enable = false: we enable servers explicitly below.
      require("mason-lspconfig").setup({ automatic_enable = false })
      require("mason-tool-installer").setup({
        ensure_installed = vim.list_extend(vim.tbl_keys(servers), tools),
      })

      -- Shared config + enable ----------------------------------------------
      vim.lsp.config("*", {
        capabilities = require("blink.cmp").get_lsp_capabilities(),
      })

      for name, cfg in pairs(servers) do
        vim.lsp.config(name, cfg)
        vim.lsp.enable(name)
      end

      -- Per-buffer behaviour -------------------------------------------------
      -- Neovim 0.11+ already provides grn (rename), gra (code action), grr, gri,
      -- grt, gO and K by default; Telescope overrides the pickers (see telescope.lua).
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp_attach", { clear = true }),
        callback = function(ev)
          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          if not client then return end

          -- Let basedpyright own hover; ruff's hover is redundant
          if client.name == "ruff" then
            client.server_capabilities.hoverProvider = false

            -- Ruff code actions: organize imports / apply all safe fixes
            vim.keymap.set("n", "<leader>co", function()
              vim.lsp.buf.code_action({ context = { only = { "source.organizeImports" } }, apply = true })
            end, { buffer = ev.buf, desc = "Organize imports (ruff)" })
            vim.keymap.set("n", "<leader>cx", function()
              vim.lsp.buf.code_action({ context = { only = { "source.fixAll" } }, apply = true })
            end, { buffer = ev.buf, desc = "Fix all (ruff)" })
          end

          if client:supports_method("textDocument/inlayHint", ev.buf) then
            vim.keymap.set("n", "<leader>th", function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = ev.buf }), { bufnr = ev.buf })
            end, { buffer = ev.buf, desc = "Toggle inlay hints" })
          end

          if client:supports_method("textDocument/documentHighlight", ev.buf) then
            local hl = vim.api.nvim_create_augroup("lsp_highlight_" .. ev.buf, { clear = true })
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              group = hl, buffer = ev.buf, callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
              group = hl, buffer = ev.buf, callback = vim.lsp.buf.clear_references,
            })
          end
        end,
      })
    end,
  },
}
