# Iron.nvim — Keymap & Usage Reference

Terminal REPL: sends code to a real `ipython` / `R` / `bash` process running in
a split. Output is plain text; you can also type into the REPL directly. Pure
Lua, no graphics stack required — works cleanly over SSH and inside any
terminal.

- **Plugin spec:** [`lua/plugins/iron.lua`](../plugins/iron.lua)
- **Keymaps:** [`lua/keymaps/iron-keymaps.lua`](./iron-keymaps.lua)
- **REPLs defined:** `python` (`ipython --no-autoindent`), `r` (`R --quiet --no-save`), `sh` (`bash`)

## Iron vs. Molten — which to reach for

Both can run Python/R, but they are different output models, not duplicates:

| Use **Iron** when…                              | Use **Molten** when…                         |
| ----------------------------------------------- | -------------------------------------------- |
| You want a **bash** REPL                        | You want **inline plots / images / LaTeX**   |
| Plain-text scratch loop, type-in-REPL           | You're driving a **Jupyter kernel / `.ipynb`** |
| Lightweight / no kernel provisioning on a host  | You need notebook output round-trip          |
| Graphics path (tmux + kitty) is unreliable      | Rich output renders fine                      |

Rule of thumb for this config: **one front-end per filetype** — Quarto runner
in `.qmd`/`.md`, Molten directly in `.ipynb`, and Iron *or* Molten in `.py`
(your choice). Iron is the dependable text fallback.

## REPL control — `<leader>c`

| Key             | Action                          | Notes                          |
| --------------- | ------------------------------- | ------------------------------ |
| `<leader>cp`    | Open REPL for Python            | `ipython`                      |
| `<leader>cr`    | Open REPL for R                 |                                |
| `<leader>cb`    | Open REPL for Bash              | uses the `sh` definition       |
| `<leader>ct`    | Toggle REPL window              | `:IronRepl`                    |
| `<leader>cf`    | Focus REPL window               | `:IronFocus`                   |
| `<leader>ch`    | Hide REPL window                | `:IronHide`                    |
| `<leader>cs`    | Restart REPL                    | `:IronRestart` (was `cR`)      |
| `<leader>cq`    | Quit / close REPL               |                                |
| `<leader>cl`    | Clear REPL screen               | sends `C-l`                    |
| `<leader>ci`    | Interrupt running cell          | sends `C-c`                    |
| `<leader>c<CR>` | Send carriage return            | sends `C-m`                    |

> **Changed:** restart moved `<leader>cR` → `<leader>cs` so it no longer
> collides with `<leader>cr` (R). The `s` is for re**s**tart — rebind if you
> prefer something else.

## Send code — `<leader>i`

**Normal mode:**

| Key          | Action                              |
| ------------ | ----------------------------------- |
| `<leader>ic` | Send by motion (`<leader>ic` + motion) |
| `<leader>if` | Send whole file                     |
| `<leader>il` | Send current line                   |
| `<leader>iu` | Send everything up to the cursor    |
| `<leader>ip` | Send current paragraph              |
| `<leader>ib` | Send current code block             |
| `<leader>in` | Send code block, then jump to next  |
| `<leader>im` | Mark by motion                      |
| `<leader>id` | Drop last mark                      |

**Visual mode:**

| Key          | Action               |
| ------------ | -------------------- |
| `<leader>iv` | Send visual selection|
| `<leader>im` | Mark visual selection|

**Both modes:**

| Key          | Action                 |
| ------------ | ---------------------- |
| `<leader>ih` | Clear mark highlight   |

> **Changed:** clear-highlight moved off the visual-mode `<leader>il` (which
> shadowed "send line") onto `<leader>ih`, bound in both modes.

## Code blocks

`send code block` (`<leader>ib`/`<leader>in`) splits on these dividers in
Python: `# %%`, `#%%`, and ` ``` `. Useful for cell-style `.py` files.

## Inside the REPL

It's an ordinary terminal buffer:

- Type commands directly into it like a normal shell/REPL.
- `<Esc><Esc>` exits terminal mode (global map in `keymaps.lua`).
- Python REPL runs with `PYTHON_BASIC_REPL=1` (needed for Python 3.13+) and
  bracketed paste for clean multi-line sends.

## Related files

- Plugin configuration: [`lua/plugins/iron.lua`](../plugins/iron.lua)
- Loader: [`lua/keymaps/keymaps.lua`](./keymaps.lua) calls
  `require("keymaps.iron-keymaps")`
