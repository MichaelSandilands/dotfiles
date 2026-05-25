# Telescope — Keymap & Usage Reference

Fuzzy finder over files, buffers, grep results, diagnostics, help tags, and more.

- **Plugin spec:** [`lua/plugins/telescope.lua`](../plugins/telescope.lua)
- **Keymaps:** [`lua/keymaps/telescope-keymaps.lua`](./telescope-keymaps.lua)
- **Extensions enabled here:** `fzf-native` (faster sorting), `ui-select` (routes `vim.ui.select` through Telescope)

## How it loads

Keymaps are registered through `which-key` at startup, but each one defers
`require("telescope.builtin")` into a closure. Telescope therefore stays
lazy-loaded and only initializes the first time you press one of these keys.

## Leader maps

All under the `[F]ind` group — press `<leader>f` and which-key shows the menu.

| Key           | Action                                  | Notes                                      |
| ------------- | --------------------------------------- | ------------------------------------------ |
| `<leader>ff`  | Find files                              | Respects `.gitignore`                      |
| `<leader>fg`  | Live grep                               | Search file contents across the project    |
| `<leader>f#`  | Live grep seeded with `#`               | Type a category (e.g. `numpy/`) to narrow tags |
| `<leader>ft`  | Pick a unique `#tag`                    | Lists all tags; select → grep its occurrences |
| `<leader>fw`  | Grep current word                       | Word under the cursor                       |
| `<leader>fb`  | Find open buffers                       |                                            |
| `<leader>fh`  | Find help tags                          | Searches `:help` docs                       |
| `<leader>fk`  | Find keymaps                            | Searches your mapped keys                   |
| `<leader>fd`  | Find diagnostics                        | LSP errors/warnings across buffers          |
| `<leader>fr`  | Resume last picker                      | Reopens the previous search + results       |
| `<leader>fs`  | Select Telescope builtin                | Picker of all available pickers             |
| `<leader>f.`  | Recent files (oldfiles)                 |                                            |
| `<leader>fn`  | Find Neovim config files                | Scoped to `stdpath("config")`               |
| `<leader>/`   | Fuzzy find in current buffer            | Dropdown theme, no preview                  |
| `<leader>f/`  | Live grep in open buffers only          |                                            |
| `zl`          | Spelling suggestions for word           | `:Telescope spell_suggest`                  |

## Navigating `#tags`

A lightweight personal taxonomy: drop hierarchical hashtags like
`#pandas/cleaning` or `#numpy/broadcasting` into code comments or prose, then
jump between them. No index to maintain — it's all ripgrep, so it works the
moment you type a tag.

- **`<leader>f#`** — live grep pre-seeded with `#`. Type a category to narrow:
  `numpy/` makes `#numpy/`, then add `broadcasting`. Spans `.py`, `.qmd`, and
  `.ipynb` because `rg` matches raw text.
- **`<leader>ft`** — picker of every *unique* tag in the project (deduped +
  sorted, with a count in the title). Selecting one drills into `grep_string`
  for that exact tag so you can jump to a specific occurrence.

Placing tags: in `.py`, a line like `#numpy/broadcasting` is just a comment; in
`.qmd`/markdown, write it inline (no space after `#`, or it becomes a heading);
inside code chunks, use a Python comment. The `#a/b/c` form is also Obsidian's
nested-tag syntax, so the same tags carry into a future vault.

> **`.ipynb` caveat:** `rg` finds tags inside the notebook JSON and opens the
> right file, but because jupytext converts the buffer on open the cursor may
> land on the wrong line. Favor `.qmd` (or a jupytext-paired `.qmd`) for tagged
> notes so jumps land precisely.

## Inside a picker

Default Telescope navigation once a window is open.

**Insert mode (default focus):**

| Key                | Action                              |
| ------------------ | ----------------------------------- |
| `<C-n>` / `<C-p>`  | Next / previous result              |
| `<Down>` / `<Up>`  | Next / previous result              |
| `<CR>`             | Open selection                      |
| `<C-x>`            | Open in horizontal split            |
| `<C-v>`            | Open in vertical split              |
| `<C-t>`            | Open in new tab                     |
| `<C-u>` / `<C-d>`  | Scroll preview up / down            |
| `<Tab>`            | Toggle selection, move to next      |
| `<C-q>`            | Send all results to quickfix + open |
| `<M-q>`            | Send selected results to quickfix   |
| `<C-/>`            | Show all picker mappings (help)     |
| `<C-c>` / `<Esc>`  | Close the picker                    |

**Normal mode (press `<Esc>` once inside a picker):**

| Key      | Action                          |
| -------- | ------------------------------- |
| `j` / `k`| Move down / up                  |
| `gg`/`G` | Jump to first / last result     |
| `<CR>`   | Open selection                  |
| `?`      | Show all picker mappings (help) |

## Tips

- `<leader>fg` (live grep) needs `ripgrep` (`rg`) on your `PATH`.
- `<leader>fr` is great after closing a picker too early — it restores the exact
  query and result list.
- Because `ui-select` is wired in, generic pickers (e.g. code actions,
  `vim.lsp.buf.*` choices) also render through Telescope.

## Related files

- Plugin configuration: [`lua/plugins/telescope.lua`](../plugins/telescope.lua)
- Loader: [`lua/keymaps/keymaps.lua`](./keymaps.lua) calls
  `require("keymaps.telescope-keymaps")`
