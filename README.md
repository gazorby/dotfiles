# dotfiles [![Generic badge](https://img.shields.io/badge/Version-v3.0.0-<COLOR>.svg)](https://shields.io/)

My personal dotfiles managed using [chezmoi](https://github.com/twpayne/chezmoi)

## 🚀 Usage

1. Ensure the dependencies are installed:

   - [chezmoi](https://github.com/twpayne/chezmoi/blob/master/docs/INSTALL.md)
   - [jq](https://stedolan.github.io/jq/)

2. Adjust [`chezmoi.default.toml`](<[https://](https://raw.githubusercontent.com/gazorby/dotfiles/master/chezmoi.default.toml)>) according to your needs:

   - Fork this repo and edit `chezmoi.default.toml` in your fork (recommended)
   - Download `chezmoi.default.toml` from this repo and edit it locally

     ```bash
     mkdir -p ~/.config/chezmoi && curl https://raw.githubusercontent.com/gazorby/dotfiles/master/chezmoi.default.toml --output ~/.config/chezmoi/chezmoi.toml
     ```

3. Open a shell and set the following variables if you want to retrieve secret keys from [bitwarden](<[https://](https://bitwarden.com/)>):

   ```bash
   export GIT_REPO='' # Your fork. Don't set it if you want to use this repo directly
   # The following is only needed if you enabled secret_* config, eg: bw_ssh_import_key
   export BW_CLIENTID=''
   export BW_CLIENTSECRET=''
   export BW_PASSWORD=''
   ```

   If bitwarden vault is used, these variables will be unset and you will be logged out from the vault after the installation

4. Install dotfiles :
   ```console
   curl -sSL https://raw.githubusercontent.com/gazorby/dotfiles/master/install.sh | sh -
   ```

## 📝 License

[MIT](https://github.com/Gazorby/dotfiles/blob/master/LICENSE)
