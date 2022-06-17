# dotfiles [![Generic badge](https://img.shields.io/badge/Version-v3.0.0-<COLOR>.svg)](https://shields.io/)

My personal dotfiles managed using [chezmoi](https://github.com/twpayne/chezmoi)

## 🚀 Usage

1) Install dependencies

   - [chezmoi](https://github.com/twpayne/chezmoi/blob/master/docs/INSTALL.md)
   - [jq](https://stedolan.github.io/jq/)

2) Fork this repository and adjust `chezmoi.default.toml` according to your needs

4) Open a shell and set the following variables:
    ```bash
    export GIT_REPO='' # Your fork
    # The following is only needed if you enabled secret_* config, eg: secret_import_ssh_key
    export BW_CLIENTID=''
    export BW_CLIENTSECRET=''
    export BW_PASSWORD=''
    ```

5) Install dotfiles :
    ```console
    curl -sSL https://raw.githubusercontent.com/gazorby/dotfiles/master/init.sh | sh -
    ```

## 📝 License

[MIT](https://github.com/Gazorby/dotfiles/blob/master/LICENSE)
