# Copilot.lua — Keymap & Usage Reference

GitHub Copilot **ghost-text** suggestions in insert mode. This config uses
Copilot's native suggestion engine (not a cmp source), so the completion menu
is still driven by blink.cmp — Copilot only paints the inline grey suggestion.

- **Plugin spec:** [`lua/plugins/copilot.lua`](../plugins/copilot.lua)
- **Keymaps:** [`lua/keymaps/copilot-keymaps.lua`](./copilot-keymaps.lua)
- **Loads on:** `InsertEnter` (and `:Copilot`)
- **Enabled filetypes:** markdown, quarto, python, r

## Keymaps (insert mode)

| Key     | Action                  |
| ------- | ----------------------- |
| `<M-l>` | Accept whole suggestion |
| `<M-w>` | Accept next word        |
| `<M-L>` | Accept next line        |
| `<M-]>` | Next suggestion         |
| `<M-[>` | Previous suggestion     |
| `<C-]>` | Dismiss suggestion      |

`<M-]>` / `<M-[>` / `<C-]>` are Copilot's defaults, kept as-is.

## Notes

- Ghost text and the blink.cmp menu coexist: blink handles the popup,
  Copilot handles the inline grey text. They don't fight because there's no
  copilot-cmp bridge.
- Run `:Copilot auth` once to sign in.
- To add/remove languages, edit the `filetypes` table in the spec.

## Related files

- Plugin configuration: [`lua/plugins/copilot.lua`](../plugins/copilot.lua)
- Completion menu: [`lua/plugins/blink-cmp.lua`](../plugins/blink-cmp.lua)
- Loader: [`lua/keymaps/keymaps.lua`](./keymaps.lua)
