# nvim-treesitter-textobjects — Keymap & Usage Reference

Syntax-aware **textobjects**: select functions, classes, scopes, and code cells
as motions, so they work with any operator (`d`, `y`, `c`, `v`, …).

- **Plugin spec:** [`lua/plugins/treesitter.lua`](../plugins/treesitter.lua)
- **Keymaps:** [`lua/keymaps/treesitter-keymaps.lua`](./treesitter-keymaps.lua)
- Uses the `main`-branch select API
  (`nvim-treesitter-textobjects.select`).

## Keymaps (operator-pending & visual: `o`, `x`)

| Key  | Selects                |
| ---- | ---------------------- |
| `af` | **a** function (outer) |
| `if` | **i**nner function     |
| `ac` | **a** class (outer)    |
| `ic` | **i**nner class        |
| `as` | **a** local scope      |
| `ib` | **i**nner code block   |
| `ab` | **a** code block (outer) |

The `af`/`if`/`ac`/`ic` set is the de-facto Vim standard, kept unchanged. The
`ib`/`ab` code-block objects use the custom query in
`after/queries/markdown/textobjects.scm` (fenced code blocks), which is what
makes them work in `.qmd`/`.md`/`.ipynb`.

## How to use

Combine with any operator or visual mode:

| Command | Effect                          |
| ------- | ------------------------------- |
| `daf`   | Delete around the function      |
| `yif`   | Yank inside the function        |
| `cic`   | Change inside the class         |
| `vab`   | Visually select a code block    |
| `=if`   | Re-indent inside the function   |

## Notes

- Treesitter is `lazy = false` (highlighting is wanted everywhere), so these
  load with the editor; the `require` is still deferred for clean ordering.
- `vim.g.no_plugin_maps = true` is set in the spec so the plugin doesn't
  install its own default maps — these are the only textobject maps.

## Related files

- Plugin configuration: [`lua/plugins/treesitter.lua`](../plugins/treesitter.lua)
- Code-cell query: `after/queries/markdown/textobjects.scm`
- Loader: [`lua/keymaps/keymaps.lua`](./keymaps.lua)
