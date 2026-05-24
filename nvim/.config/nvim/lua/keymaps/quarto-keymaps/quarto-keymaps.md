# Quarto-nvim — Keymap & Usage Reference

Literate-programming support for `.qmd` (and `.md`) documents: runs code cells,
previews rendered output, and provides LSP/completion inside code chunks via
otter.nvim. Cell execution is delegated to **Molten** (`default_method =
"molten"`), so "run cell" here drives your Jupyter kernel.

- **Plugin spec:** [`lua/plugins/quarto.lua`](../plugins/quarto.lua)
- **Keymaps:** [`lua/keymaps/quarto-keymaps.lua`](./quarto-keymaps.lua)
- **Loads on:** `quarto` and `markdown` filetypes (`ft` trigger)

## Namespace split

| Prefix                 | Purpose                              |
| ---------------------- | ------------------------------------ |
| `<leader>q` (space-q)  | Document / session: preview, help    |
| `<localleader>q` (`,q`)| Run code in this buffer (cell runners) |

The cell runners live under `<localleader>` because they're in-buffer code
execution — the same namespace as Molten's direct maps.

## Document / session — `<leader>q`

| Key          | Action                          |
| ------------ | ------------------------------- |
| `<leader>qp` | Start live preview              |
| `<leader>qu` | Update / refresh preview        |
| `<leader>qq` | Close ("quiet") preview         |
| `<leader>qh` | `:QuartoHelp` — type a topic    |
| `<leader>qm` | Toggle math rendering (nabla)*  |

\* `<leader>qm` is defined in [`lua/plugins/nabla.lua`](../plugins/nabla.lua),
not here — it just shows up in this group.

## Cell runners — `<localleader>q`

| Key                | Action                              |
| ------------------ | ----------------------------------- |
| `<localleader>qrc` | Run current cell                    |
| `<localleader>qra` | Run current cell **and** above      |
| `<localleader>qrA` | Run **all** cells                   |
| `<localleader>qrl` | Run current line                    |
| `<localleader>qrr` | Run visual range *(visual mode)*    |
| `<localleader>qRA` | Run all cells, **all languages**    |

**Capitalization convention** (now consistent): lowercase is the scoped
action, UPPERCASE is the "all" variant — `qra` (above) → `qrA` (all cells), and
`qr*` (this language) → `qR*` (all languages).

## Quarto vs. Molten — when to use which

Both run cells in a `.qmd`. The convention for this config:

- **`.qmd` / `.md`** → use the **Quarto runners** (`<localleader>qr*`). They
  understand the document structure and hand execution to Molten.
- **`.ipynb` / `.py`** → use **Molten directly** (`<localleader>m*`), since
  there's no Quarto document wrapping those cells.

So the two namespaces aren't duplicates: Quarto is the document-aware front-end,
Molten is the kernel-level control.

## Requirements

- A running Quarto CLI for preview (`quarto` on `PATH`).
- Molten initialized for cell execution (see molten-keymaps.md). The config
  auto-initializes Molten with the active conda/venv kernel when you enter a
  `.qmd`/`.md` buffer.

## Related files

- Plugin configuration: [`lua/plugins/quarto.lua`](../plugins/quarto.lua)
- Cell execution backend: [`molten-keymaps.md`](./molten-keymaps.md)
- Loader: [`lua/keymaps/keymaps.lua`](./keymaps.lua) calls
  `require("keymaps.quarto-keymaps")`
