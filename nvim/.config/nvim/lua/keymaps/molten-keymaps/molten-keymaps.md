# Molten-nvim — Keymap & Usage Reference

Jupyter-kernel client. Sends code to a live kernel and renders **rich inline
output** — matplotlib/plotly images (via image.nvim on the kitty backend),
dataframes, LaTeX — directly in the buffer. Handles `.ipynb` output round-trip.

- **Plugin spec:** [`lua/plugins/molten.lua`](../plugins/molten.lua)
- **Keymaps:** [`lua/keymaps/molten-keymaps.lua`](./molten-keymaps.lua)
- **Loads:** eagerly (`lazy = false`) — its `init` must register `.ipynb`
  autocmds and `vim.g` options before a notebook opens.

## Keymaps — `<localleader>m` (`,m`)

| Key                | Action                                   |
| ------------------ | ---------------------------------------- |
| `<localleader>mi`  | Init kernel (prompts for kernel choice)  |
| `<localleader>mp`  | Init kernel from active conda/venv, else `python3` |
| `<localleader>me`  | Evaluate operator (`,me` + a motion)     |
| `<localleader>mc`  | Re-evaluate current cell                  |
| `<localleader>mo`  | Enter / show the output window            |
| `<localleader>mh`  | Hide output                               |
| `<localleader>md`  | Delete cell                               |
| `<localleader>mv`  | Evaluate visual selection *(visual mode)* |

> **Changed:** the env-aware init was on `<leader>mp`; it now sits at
> `<localleader>mp` so all of Molten lives in one namespace.

## Auto-behavior (no keys needed)

The spec wires several autocommands:

- Opening a `.ipynb` auto-initializes the kernel (active env → notebook
  metadata fallback) and imports saved outputs.
- Saving a `.ipynb` exports outputs back into the notebook.
- Entering a `.qmd`/`.md` buffer silently initializes Molten with the active
  env kernel if one isn't running.
- Virtual-text output settings flip automatically between `.py` (off) and
  `.qmd`/`.md`/`.ipynb` (on).
- `:NewNotebook <name>` creates a blank `.ipynb` with valid metadata.

## Requirements

- **Python provider env** with `pynvim` and `jupyter_client` (see
  `vim.g.python3_host_prog` in `options.lua`).
- Run **`:UpdateRemotePlugins`** after install/upgrade (it's the `build` step).
- A registered Jupyter **kernel** for your env (e.g. `python -m ipykernel
  install --user --name <env>`).
- **kitty** terminal for inline images (via image.nvim). Over SSH, kitty's
  graphics protocol forwards; through **tmux** it's the fragile link — if plots
  misbehave there, fall back to Iron's text REPL.

## Molten vs. Iron

| Use **Molten** when…                       | Use **Iron** when…                       |
| ------------------------------------------ | ---------------------------------------- |
| You want inline plots / images / LaTeX     | You want a bash REPL                      |
| Driving a Jupyter kernel or `.ipynb`       | Plain-text scratch loop                   |
| Notebook output round-trip                 | No kernel provisioning on the host        |
| Rich output renders reliably               | tmux+kitty graphics path is flaky         |

See [`iron-keymaps.md`](./iron-keymaps.md) for the other side.

## Related files

- Plugin configuration: [`lua/plugins/molten.lua`](../plugins/molten.lua)
- Image backend: `3rd/image.nvim` (configured in the same spec)
- Loader: [`lua/keymaps/keymaps.lua`](./keymaps.lua) calls
  `require("keymaps.molten-keymaps")`
