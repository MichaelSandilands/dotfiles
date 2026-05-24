# dotfiles

Personal configuration for a terminal-based **Python / R / Quarto** data-science
workflow, managed with [GNU Stow](https://www.gnu.org/software/stow/).

| Package | What it configures |
| ------- | ------------------ |
| `nvim`  | Neovim (lazy.nvim, LSP, Treesitter, Molten/Quarto notebooks, Iron REPLs, DAP) |
| `kitty` | Kitty terminal — fonts, Carbonfox theme, image protocol, open-actions |
| `tmux`  | tmux — Carbonfox status line, TPM plugins, `C-a` prefix |

The directories mirror `~/.config`, so `stow` symlinks them straight into place.

---

## Install

```sh
git clone https://github.com/MichaelSandilands/dotfiles.git ~/dotfiles
cd ~/dotfiles
stow nvim kitty tmux
```

`stow` creates symlinks like `~/.config/nvim -> ~/dotfiles/nvim/.config/nvim`.
Existing files at those paths will make Stow refuse — move them aside first.

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
compat-lua          # Lua 5.1 compat, needed by image.nvim's magick rock

# System utilities
stow
```

### Ubuntu / Debian equivalent

Ubuntu's repositories lag badly on the things that matter most here
(**Neovim especially** — this config needs **0.11+** for `vim.hl.on_yank`,
`vim.diagnostic` virtual lines, the `gr*` LSP defaults, and the Treesitter
`main` branch). It also does **not** pull the runtime tools in transitively, so
they have to be installed by hand.

| Purpose | Fedora 43 | Ubuntu / Debian |
| ------- | --------- | --------------- |
| Editor | `neovim` | **Not apt** — too old. Use the unstable PPA or a release tarball (see below) |
| Nerd Font | `cascadia-mono-nf-fonts` | Manual install — apt's `fonts-cascadia-code` is **not** Nerd-Font-patched (see below) |
| Terminal | `kitty` | `kitty` exists but lags; prefer the official installer (below) |
| Multiplexer | `tmux` | `tmux` |
| Python provider | `python3-neovim` | `python3-pynvim` (or just rely on the venv below) |
| Lua rocks | `luarocks` | `luarocks` |
| Lua 5.1 compat | `compat-lua` | `lua5.1 liblua5.1-0-dev` |
| Image rendering | `ImageMagick` | `imagemagick libmagickwand-dev` |
| Symlink manager | `stow` | `stow` |
| Fuzzy search *(transitive on Fedora)* | — | `ripgrep` |
| File finder *(transitive on Fedora)* | — | `fd-find` — binary is `fdfind`, symlink it to `fd` (below) |
| Build toolchain *(transitive on Fedora)* | — | `build-essential` (Treesitter parsers + `fzf-native` compile on install) |
| Clipboard *(transitive on Fedora)* | — | `wl-clipboard` (Wayland) or `xclip` (X11) — needed for `clipboard=unnamedplus` |
| LSP runtime *(transitive on Fedora)* | — | `nodejs` — required by `pyright` and the web LSPs (`html`, `cssls`, `jsonls`, `yamlls`) |

```sh
# Base packages
sudo apt update
sudo apt install -y tmux luarocks lua5.1 liblua5.1-0-dev \
  imagemagick libmagickwand-dev stow \
  ripgrep fd-find build-essential nodejs npm \
  python3-venv python3-pynvim wl-clipboard

# Ubuntu ships fd as `fdfind`; Telescope/tools expect `fd`
mkdir -p ~/.local/bin
ln -sf "$(command -v fdfind)" ~/.local/bin/fd   # ensure ~/.local/bin is on $PATH

# Neovim 0.11+ — apt is too old, use the unstable PPA
sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt update && sudo apt install -y neovim
# (alternatively: download the release tarball/AppImage from
#  https://github.com/neovim/neovim/releases)

# Kitty — official installer (apt build lags)
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin

# Cascadia Code Nerd Font (the NF variant is not in apt)
mkdir -p ~/.local/share/fonts && cd ~/.local/share/fonts
curl -fLO https://github.com/ryanoasis/nerd-fonts/releases/latest/download/CascadiaMono.zip
unzip -o CascadiaMono.zip -d CascadiaMono && rm CascadiaMono.zip
fc-cache -f
```

> **R support is optional.** The config wires up `r_language_server`, an R REPL,
> and the `styler` formatter, but everything runs fine Python-only. Install R
> separately if you want it.

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
