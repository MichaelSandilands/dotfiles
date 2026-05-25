# render-markdown.nvim — Keymap & Usage Reference

In-buffer rendering for markdown / Quarto: headings, tables, code-block
backgrounds, checkboxes, and concealed markup are drawn inline while you edit.
Rendering is on by default; these maps toggle it and adjust how much raw markup
shows around the cursor.

- **Plugin spec:** [`lua/plugins/render-markdown.lua`](../plugins/render-markdown.lua)
- **Keymaps:** [`lua/keymaps/render-markdown-keymaps.lua`](./render-markdown-keymaps.lua)
- **Loads on:** `markdown` and `quarto` filetypes (`ft` trigger)

## Namespace

`<leader>m` (space-m) = **[m]arkdown render**. Distinct from Molten's
`<localleader>m` (`,m`) kernel namespace — the two don't overlap.

## Keymaps — `<leader>m`

| Key          | Action                                          |
| ------------ | ----------------------------------------------- |
| `<leader>mt` | Toggle rendering on / off                       |
| `<leader>me` | Expand the raw-text region around the cursor    |
| `<leader>mc` | Contract the raw-text region around the cursor  |

**Anti-conceal:** by default the line under the cursor shows raw markup
(`**bold**`, `# heading`, table pipes) while every other line is rendered.
`expand` / `contract` grow and shrink how many lines around the cursor stay
raw — handy when editing a table or a dense block.

## Notes

- The `:RenderMarkdown` command (and therefore these maps) is created when the
  plugin loads, which happens on `markdown` / `quarto` buffers. Pressing them
  in another filetype won't do anything useful.
- Needs the `markdown` and `markdown_inline` Treesitter parsers — already pulled
  in by the Quarto / otter setup. Verify with `:checkhealth render-markdown`.

## Related files

- Plugin configuration: [`lua/plugins/render-markdown.lua`](../plugins/render-markdown.lua)
- Loader: [`lua/keymaps/keymaps.lua`](./keymaps.lua) calls
  `require("keymaps.render-markdown-keymaps")`
