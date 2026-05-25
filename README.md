# dotfiles

Personal configuration for a terminal-based **Python / R / Quarto** data-science
workflow, managed with [GNU Stow](https://www.gnu.org/software/stow/).

| Package   | What it configures                                                               |
| --------- | -------------------------------------------------------------------------------- |
| `ipython` | This script automatically executes when launching an interactive IPython session |
| `nvim`    | Neovim (lazy.nvim, LSP, Treesitter, Molten/Quarto notebooks, Iron REPLs, DAP)    |
| `kitty`   | Kitty terminal — fonts, Carbonfox theme, image protocol, open-actions            |
| `tmux`    | tmux — Carbonfox status line, TPM plugins, `C-a` prefix                          |

The directories mirror `~/.config`, so `stow` symlinks them straight into place.

---

## Install

```sh
git clone https://github.com/MichaelSandilands/dotfiles.git ~/dotfiles
cd ~/dotfiles
stow ipython nvim kitty tmux
```

`stow` creates symlinks like `~/.config/nvim -> ~/dotfiles/nvim/.config/nvim`.
Existing files at those paths will make Stow refuse — move them aside first.

Also set `export EDITOR=nvim` in your shell rc — kitty's `open-actions.conf`
uses `$EDITOR` to open files (e.g. clicking a file path opens it in Neovim).

---

## Dependencies

### Fedora 43

Fedora is convenient here because the `neovim` package pulls in most of the
runtime tools (ripgrep, fd, a C toolchain, clipboard helpers, etc.) as
dependencies, so the explicit list stays short:

```
# Terminal & fonts
cascadia-mono-nf-fonts
kitty
tmux

# Neovim & dependencies
neovim
python3-neovim
luarocks
ImageMagick
compat-lua          # Lua 5.1, so luarocks can build plugin rockspecs (see note below)
gcc                 # C compiler for Treesitter parsers + telescope-fzf-native
make
wl-clipboard        # system clipboard for clipboard=unnamedplus (Wayland)

# System utilities
stow
```

### Ubuntu / Debian equivalent

Ubuntu's repositories lag badly on the things that matter most here
(**Neovim especially** — this config needs **0.11+** for `vim.hl.on_yank`,
`vim.diagnostic` virtual lines, the `gr*` LSP defaults, and the Treesitter
`main` branch). It also does **not** pull the runtime tools in transitively, so
each has to be installed by hand. Package names and the best install method
drift over time, so treat the table below as a checklist and track down the
current approach for each rather than copy-pasting commands:

| Purpose                               | Fedora 43                | Ubuntu / Debian                                                                                                                        |
| ------------------------------------- | ------------------------ | -------------------------------------------------------------------------------------------------------------------------------------- |
| Editor                                | `neovim`                 | **Not apt** — too old. Use the `ppa:neovim-ppa/unstable` PPA, or a release tarball/AppImage from the Neovim releases page              |
| Nerd Font                             | `cascadia-mono-nf-fonts` | Manual install — apt's `fonts-cascadia-code` is **not** Nerd-Font-patched. Use the `Cascadia*NF` builds from Microsoft's Cascadia Code |
| Terminal                              | `kitty`                  | apt's build lags; prefer the official installer from sw.kovidgoyal.net                                                                 |
| Multiplexer                           | `tmux`                   | `tmux`                                                                                                                                 |
| Python provider                       | `python3-neovim`         | `python3-pynvim` (or just rely on the venv below)                                                                                      |
| Lua rocks                             | `luarocks`               | `luarocks`                                                                                                                             |
| Lua 5.1                               | `compat-lua`             | `lua5.1 liblua5.1-0-dev`                                                                                                               |
| Image rendering                       | `ImageMagick`            | `imagemagick`                                                                                                                          |
| Symlink manager                       | `stow`                   | `stow`                                                                                                                                 |
| Fuzzy search _(transitive on Fedora)_ | —                        | `ripgrep`                                                                                                                              |
| File finder _(transitive on Fedora)_  | —                        | `fd-find` — the binary is `fdfind`; symlink it to `fd` on `$PATH`                                                                      |
| Build toolchain                       | `gcc make`               | `build-essential` (Treesitter parsers + `fzf-native` compile on install)                                                               |
| Clipboard                             | `wl-clipboard`           | `wl-clipboard` (Wayland) or `xclip` (X11) — needed for `clipboard=unnamedplus`                                                         |
| LSP runtime _(transitive on Fedora)_  | —                        | `nodejs` — required by `pyright` and the web LSPs (`html`, `cssls`, `jsonls`, `yamlls`)                                                |
| Quarto CLI                            | from quarto.org          | from quarto.org                                                                                                                        |

> **R support is optional.** The config wires up `r_language_server`, an R REPL,
> and the `styler` formatter, but everything runs fine Python-only. Install R
> separately if you want it.

> **LaTeX is optional.** The `texlab` LSP and `pnglatex` (math → PNG in Molten
> output, installed in the provider venv below) only do something useful with a
> TeX distribution (e.g. TeX Live) installed. `nabla` renders math inline
> without LaTeX, so it's only needed if you actually build `.tex`.

> **Why LuaRocks + Lua 5.1?** A few plugins ship a LuaRocks rockspec that
> lazy.nvim builds automatically — e.g. image.nvim's `magick` and plenary.nvim's
> `luassert`. Keeping `luarocks` and a system Lua 5.1 (`compat-lua`) means those
> build cleanly instead of lazy falling back to bootstrapping its own
> `hererocks`, which saves headaches down the road.

> **Quarto CLI required.** `<leader>qp` preview/render shells out to the
> `quarto` binary, which isn't in the distro repos in a current-enough form —
> install it from <https://quarto.org>.

---

## Neovim Python environment

The config points Neovim's Python provider at a dedicated venv
(`vim.g.python3_host_prog = ~/.virtualenvs/neovim/bin/python3`). **Create this
venv before launching Neovim** — Molten registers a remote plugin at build time
and will silently no-op if `pynvim` isn't available.

See the Molten guide:
<https://github.com/benlubas/molten-nvim/blob/main/docs/Virtual-Environments.md>

```sh
mkdir ~/.virtualenvs
python -m venv ~/.virtualenvs/neovim          # create the provider venv
source ~/.virtualenvs/neovim/bin/activate     # bash/zsh; use activate.fish for fish
pip install pynvim jupyter_client cairosvg plotly kaleido pnglatex pyperclip nbformat
```

### Per-project Jupyter kernel

Each project you run notebooks/REPLs in needs its own `ipykernel` registered so
Molten can find it:

```sh
source ~/.virtualenvs/project_name/bin/activate    # your project venv
pip install ipykernel
python -m ipykernel install --user --name project_name
```

Molten's `<localleader>mp` and the `*.qmd`/`*.md` auto-init read `$VIRTUAL_ENV` /
`$CONDA_PREFIX` and match the env name to a kernel, so naming the kernel after
the venv makes initialization automatic.

---

## First launch

1. **Create the provider venv first** (above) so the remote plugin builds.
2. Start `nvim`. lazy.nvim bootstraps itself and installs all plugins; Mason
   installs the LSP servers, formatters, and `jupytext`.
3. If Molten commands are missing, run `:UpdateRemotePlugins` and restart.
   Background on why this step exists:
   <https://github.com/benlubas/molten-nvim/blob/main/docs/Not-So-Quick-Start-Guide.md#a-note-on-remote-plugins>
4. **Authenticate Copilot** — needs an active GitHub Copilot subscription. Run
   `:Copilot auth` and follow the device-code prompt. The token is stored under
   `~/.config/github-copilot/` and shared across editors, so it's a one-time
   step per machine; verify with `:Copilot status`.

### tmux plugins

Plugins are managed by [TPM](https://github.com/tmux-plugins/tpm):

```sh
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

Then start tmux and press `prefix + I` (here `C-a` then `I`) to install them.

---

## Layout

```
.
├── kitty/.config/kitty/      # kitty.conf, theme, open-actions
├── nvim/.config/nvim/        # init.lua + lua/{options,config,keymaps,plugins,...}
└── tmux/.config/tmux/        # tmux.conf
```

Each Neovim plugin's keymaps live in their own module under
`lua/keymaps/` with a companion `.md` reference.
