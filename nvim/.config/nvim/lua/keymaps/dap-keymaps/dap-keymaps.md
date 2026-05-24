# nvim-dap — Keymap & Usage Reference

Debug Adapter Protocol client: breakpoints, stepping, REPL, and a UI
(nvim-dap-ui). Configured for Python via nvim-dap-python + debugpy.

- **Plugin spec:** [`lua/plugins/nvim-dap.lua`](../plugins/nvim-dap.lua)
- **Keymaps:** [`lua/keymaps/dap-keymaps.lua`](./dap-keymaps.lua)
- **Testing:** moved out — see [`neotest-keymaps.md`](./neotest-keymaps.md) (`<leader>t`)

## Lazy-loading

Add `lazy = true` to the nvim-dap spec:

```lua
return {
	"mfussenegger/nvim-dap",
	lazy = true,             -- loads on first <leader>d keypress
	dependencies = { ... },  -- unchanged
	config = function() ... end,
}
```

The keymap closures `require("dap")`, which triggers the load (and runs
`config`, wiring the dap-ui auto open/close listeners and dap-python).

## Keymaps — `<leader>d`

| Key          | Action                  |
| ------------ | ----------------------- |
| `<leader>db` | Toggle breakpoint       |
| `<leader>dc` | Continue / start        |
| `<leader>do` | Step **over**           |
| `<leader>dO` | Step **out**            |
| `<leader>di` | Step **into**           |
| `<leader>dr` | Open debug REPL         |
| `<leader>du` | Toggle dap-ui           |

**Capitalization convention:** lowercase steps into the smaller scope,
UPPERCASE steps out/further — `do` (over) vs `dO` (out).

## Notes

- dap-ui opens automatically when a session initializes and closes when it
  ends (listeners set in the spec's `config`).
- Python debugging uses `debugpy` (installed via mason-nvim-dap) and
  `require("dap-python").setup("python3")`.
- A common addition is "run to cursor" or "terminate" — add to the file if you
  want them.

## Related files

- Plugin configuration: [`lua/plugins/nvim-dap.lua`](../plugins/nvim-dap.lua)
- Testing namespace: [`neotest-keymaps.md`](./neotest-keymaps.md)
- Loader: [`lua/keymaps/keymaps.lua`](./keymaps.lua)
