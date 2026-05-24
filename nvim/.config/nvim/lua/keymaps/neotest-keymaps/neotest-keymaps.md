# neotest — Keymap & Usage Reference

Test runner. Runs the nearest test, a whole file, or debugs a test through DAP,
and shows results in a summary panel and output window. Configured with the
Python adapter (neotest-python).

- **Plugin spec:** [`lua/plugins/neotest.lua`](../plugins/neotest.lua)
- **Keymaps:** [`lua/keymaps/neotest-keymaps.lua`](./neotest-keymaps.lua)

## Why `<leader>t` and not `<leader>dt`

Testing was nested three keys deep under the debug group (`<leader>dtt`, etc.).
It now has its own top-level namespace, since testing isn't debugging — even
though `<leader>td` launches a test *via* DAP.

## Lazy-loading

Add `lazy = true` to the neotest spec:

```lua
return {
	"nvim-neotest/neotest",
	lazy = true,             -- loads on first <leader>t keypress
	dependencies = { ... },  -- unchanged
	config = function() ... end,
}
```

The closures `require("neotest")`, which triggers the load.

## Keymaps — `<leader>t`

| Key          | Action                          |
| ------------ | ------------------------------- |
| `<leader>tt` | Run nearest test *(new)*        |
| `<leader>tf` | Run all tests in file           |
| `<leader>td` | Debug nearest test (DAP)        |
| `<leader>ts` | Stop the current run            |
| `<leader>ta` | Attach to running test          |
| `<leader>to` | Open output window *(new)*      |
| `<leader>tp` | Toggle summary panel            |

*(new)* = not in the original layout. `tt` (plain run nearest) and `to` (output)
are standard neotest maps added while there was namespace room — remove if you
don't want them.

## Notes

- `<leader>td` reuses your DAP setup as the test strategy, so debugpy must be
  available (it is, via mason-nvim-dap).
- The summary panel (`<leader>tp`) is where you navigate and re-run individual
  tests.

## Related files

- Plugin configuration: [`lua/plugins/neotest.lua`](../plugins/neotest.lua)
- Debug namespace: [`dap-keymaps.md`](./dap-keymaps.md)
- Loader: [`lua/keymaps/keymaps.lua`](./keymaps.lua)
