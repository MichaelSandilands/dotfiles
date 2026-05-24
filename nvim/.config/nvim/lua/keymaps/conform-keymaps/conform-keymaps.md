# Conform.nvim — Keymap & Usage Reference

Formatter runner. Maps filetypes to external formatters and runs them on
demand (and on save, via the spec's `BufWritePre` event).

- **Plugin spec:** [`lua/plugins/conform.lua`](../plugins/conform.lua)
- **Keymaps:** [`lua/keymaps/conform-keymaps.lua`](./conform-keymaps.lua)
- **Loads on:** `BufWritePre`, `:ConformInfo`

## Keymap

| Key         | Mode | Action                                     |
| ----------- | ---- | ------------------------------------------ |
| `<leader>=` | n, v | Format buffer (or selection), async        |

Uses `lsp_format = "fallback"` — runs the configured formatter, and falls back
to the LSP formatter if none is set for that filetype.

## Configured formatters

| Filetype                     | Formatter(s)                       |
| ---------------------------- | ---------------------------------- |
| lua                          | stylua                             |
| python                       | ruff_format                        |
| r                            | styler                             |
| javascript / typescript      | prettierd → prettier               |
| yaml / json / jsonc          | prettierd → prettier               |
| toml                         | taplo                              |
| sh / bash                    | shfmt                              |
| quarto / markdown            | `injected` (formats embedded code) |

The `injected` formatter reformats fenced code inside `.qmd`/`.md` using each
language's own formatter (Python via ruff, SQL, etc.).

## Notes

- `:ConformInfo` shows which formatters are available and what ran.
- Formatters must be installed — most are handled by mason-tool-installer
  (see `lua/plugins/lsp-config.lua`); `styler` is an R package.

## Related files

- Plugin configuration: [`lua/plugins/conform.lua`](../plugins/conform.lua)
- Tool installation: [`lua/plugins/lsp-config.lua`](../plugins/lsp-config.lua)
- Loader: [`lua/keymaps/keymaps.lua`](./keymaps.lua)
