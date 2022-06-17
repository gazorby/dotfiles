# dotfiles [![Generic badge](https://img.shields.io/badge/Version-v3.0.0-<COLOR>.svg)](https://shields.io/)

My personal dotfiles managed using [chezmoi](https://github.com/twpayne/chezmoi)

## 🚀 Install

1) [Install chezmoi](https://github.com/twpayne/chezmoi/blob/master/docs/INSTALL.md)

2) Create `~/.config/chezmoi/chezmoi.toml`:
   ```console
   curl https://raw.githubusercontent.com/gazorby/dotfiles/feat/master/chezmoi.toml.example --output ~/.config/chezmoi/chezmoi.toml
   ```
   Adjust according to your needs

3) Install dotfiles :
    ```console
    curl -sSL https://raw.githubusercontent.com/gazorby/dotfiles/master/init.sh | sh -
    ```

## 📝 License

[MIT](https://github.com/Gazorby/dotfiles/blob/master/LICENSE)
