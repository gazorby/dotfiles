# dotfiles

My personal dotfiles managed using [chezmoi](https://github.com/twpayne/chezmoi)

## ✨ Features

- **Shell**: fish with fisher plugins, starship prompt, atuin history, zoxide, fzf pickers (files, git log/status, processes) and completions generated on first apply
- **Git**: delta as pager with clickable file links, zdiff3 conflicts, rebase on pull, optional commit signing, separate identity for a work directory, lazygit and `pr_delta` to read GitHub PR / GitLab MR diffs
- **Editors**: [helix](https://helix-editor.com), [mitos](https://github.com/mitos-editor/mitos) (default `$EDITOR`) and [neovim](https://neovim.io), with LSPs and format on save for Python, Lua, TOML, YAML, JSON and TypeScript
- **Terminals**: [WezTerm](https://wezterm.org) (pane splits, most-recently-used tab cycling, delta links opened in `$EDITOR`) and [Ghostty](https://ghostty.org)
- **Theme**: one Monokai Pro palette (`.chezmoidata/theme.toml`) rendered into WezTerm, Ghostty, helix, mitos, lazygit, glab-tui and fzf, following macOS light/dark appearance
- **SSH**: agent started at login with keys loaded, connection multiplexing

## 🧰 Requirements

Tools the configs call or configure. A missing optional tool only disables the feature listed next to it.

### Shell

| Tool                                              | Used by                                                     |
| ------------------------------------------------- | ----------------------------------------------------------- |
| [fish](https://fishshell.com)                     | Main shell, `~/.config/fish`; plugins installed with fisher |
| [starship](https://starship.rs)                   | Prompt, `starship.toml`                                     |
| [atuin](https://atuin.sh)                         | Shell history, `alt-r` search                               |
| [zoxide](https://github.com/ajeetdsouza/zoxide)   | Directory jumping                                           |
| [vivid](https://github.com/sharkdp/vivid)         | `LS_COLORS`                                                 |
| [fzf](https://github.com/junegunn/fzf)            | fzf.fish, forgit, fifc plugins, `fif`, `vsr`                |
| [fd](https://github.com/sharkdp/fd)               | fzf.fish directory search and its reload bindings           |
| [ripgrep](https://github.com/BurntSushi/ripgrep)  | `fif`, `vsr`, fifc `**` completion                          |
| [bat](https://github.com/sharkdp/bat)             | `b` abbr, `MANPAGER`, `watcher`, fzf previews               |
| [bat-extras](https://github.com/eth-p/bat-extras) | `batgrep` in fifc `**` completion                           |
| [eza](https://github.com/eza-community/eza)       | fish-exa plugin, fzf and fifc directory previews            |
| [broot](https://github.com/Canop/broot)           | `br` function                                               |
| [procs](https://github.com/dalance/procs)         | Process viewer, completions in `run_once_init.sh`           |
| awk                                               | `pathclean`                                                 |
| [highlight](http://www.andre-simon.de)            | `fif` preview (optional, falls back to ripgrep)             |
| [thefuck](https://github.com/nvbn/thefuck)        | `fuck` function                                             |

### Git

| Tool                                                    | Used by                                                    |
| ------------------------------------------------------- | ---------------------------------------------------------- |
| [git-delta](https://github.com/dandavison/delta)        | Git pager, lazygit, fzf.fish diffs, `gdv` abbr, `pr_delta` |
| [lazygit](https://github.com/jesseduffield/lazygit)     | `lzg`/`lzgf` abbrs, nvim lazygit plugin                    |
| [lazyworktree](https://github.com/chmouel/lazyworktree) | `lzw` function                                             |
| [gh](https://cli.github.com)                            | `pr_delta` on GitHub repos                                 |
| [glab](https://gitlab.com/gitlab-org/cli)               | `pr_delta` on GitLab repos, nvim gitlab plugin             |
| [glab-tui](https://github.com/rcieri/glab-tui)          | `gt`/`glt` abbrs, `~/.config/glab-tui`                     |

### Repo development

Installed by `mise install` from `mise.toml`: actionlint, cocogitto, pre-commit, tombi, yamlfmt. Run `mise run install` to set up the pre-commit hooks.

## 🚀 Usage

1. Install the [requirements](#-requirements).

2. Init and apply:

   ```bash
   sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply gazorby
   ```

   You are prompted for git username, email and signing key (leave empty to disable commit signing).
   Other settings live in `~/.config/chezmoi/chezmoi.toml`, see `.chezmoi.example.toml`.

## 📝 License

[MIT](https://github.com/Gazorby/dotfiles/blob/master/LICENSE)
