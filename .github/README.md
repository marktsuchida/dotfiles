# dotfiles

Note: This repo is public for my own convenience, but I might rewrite history
on the main branch at any time. If you find any unencrypted credentials in the
commit history, they are long revoked so don't bother reporting.

## Setting up with [chezmoi](https://www.chezmoi.io/):

1. On Windows, make sure symbolic links are enabled. To do so without enabling
   Developer Mode, open **Local Group Policy Editor** and add my username to
   `Computer Configuration` > `Windows Settings` > `Security Settings` > `Local
   Policies` > `User Rights Assignment` > `Create symbolic links`.

2. [Install](https://www.chezmoi.io/install/) chezmoi.

    - macOS: `brew install chezmoi`
    - Ubuntu: `sudo snap install chezmoi --classic`
    - Windows: `scoop install chezmoi`

On machines where I use Git Credential Manager and on temporary machines where
I won't change dotfiles:

3. `chezmoi init --apply marktsuchida` (uses HTTPS)

On machines where I use SSH for Git:

3. `ssh-keygen -t ed25519 -a 256 -C <email/comment>` (with passphrase)

4. Add `~/.ssh/id_ed25519.pub` [to GitHub](https://github.com/settings/keys).

5. `chezmoi init --apply --ssh marktsuchida`

## Manual settings

### Mapping Caps Lock to Ctrl

- On Windows, use Microsoft PowerToys > Keyboard Manager.
