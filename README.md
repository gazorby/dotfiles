# dotfiles

My personal dotfiles managed using [chezmoi](https://github.com/twpayne/chezmoi)

## 🚀 Usage

1. Install dependencies:

   ```console
   openssh chezmoi fish starship vivid fzf bat fd ripgrep eza bat-extras broot procs atuin git-delta awk mise zoxide
   ```

2. Init and apply:

   ```bash
   sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply gazorby
   ```

   You are prompted for git username, email and signing key (leave empty to disable commit signing).
   Other settings live in `~/.config/chezmoi/chezmoi.toml`, see `.chezmoi.example.toml`.

## 📝 License

[MIT](https://github.com/Gazorby/dotfiles/blob/master/LICENSE)
