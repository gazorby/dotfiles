# dotfiles [![Generic badge](https://img.shields.io/badge/Version-v3.0.0-<COLOR>.svg)](https://shields.io/)

My personal dotfiles managed using [chezmoi](https://github.com/twpayne/chezmoi)

## 🚀 Install

1) [Install chezmoi](https://github.com/twpayne/chezmoi/blob/master/docs/INSTALL.md)

2) Create `~/.config/chezmoi/chezmoi.toml`:
   ```console
   curl https://raw.githubusercontent.com/gazorby/dotfiles/feat/master/chezmoi_example.toml --output ~/.config/chezmoi/chezmoi.toml
   ```
   Adjust according to your needs

3) Install dotfiles :
    ```console
    chezmoi init --apply https://github.com/gazorby/dotfiles.git
    ```

## 📝 License

[MIT](https://github.com/Gazorby/dotfiles/blob/master/LICENSE)
