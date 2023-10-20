# dotfiles [![Generic badge](https://img.shields.io/badge/Version-v3.0.0-<COLOR>.svg)](https://shields.io/)

My personal dotfiles managed using [chezmoi](https://github.com/twpayne/chezmoi)

## 🚀 Usage

1. Install dependencies:

   ```console
   openssh chezmoi fish starship vivid fzf bat fd ripgrep eza bat-extras broot procs atuin git-delta bitwarden-cli awk
   ```

2. Create the bitwarden item

   Create a bitwarden item called "chezmoi" with the following:

   Fields:

   - `git_signing_key_id`

     The gpg signing key id used to fill the `signingKey` git setting

   - `gpg_passphrase`

     The passphrase of the git gpg key

   Attachments:

   - ssh private key (default to `id_rsa`)
   - ssh public key (default to `id_rsa.pub`)
   - gpg key (default to `gpg.key`)

3. Ensure the dependencies are installed:

   - [chezmoi](https://github.com/twpayne/chezmoi/blob/master/docs/INSTALL.md)
   - [bitwarden-cli](https://github.com/bitwarden/clients)

4. Login to bitwarden and set the `BW_SESSION` variable:

   ```bash
   bw login
   bw unlock
   export BW_SESSION=<session-key> # bash
   set -x BW_SESSION <session-key> # fish
   ```

   session key is displayed when issuing `bw unlock`

5. Init chezmoi repo:

   ```bash
   chezmoi init gazorby/dotfiles
   ```

6. Adjust `~/.config/chezmoi/chezmoi.toml` according to your needs

7. Apply dotfiles

   ```bash
   chezmoi apply
   ```

## 📝 License

[MIT](https://github.com/Gazorby/dotfiles/blob/master/LICENSE)
