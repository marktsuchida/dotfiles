# dotfiles

Setting up with [chezmoi](https://www.chezmoi.io/):

1. On Windows, make sure symbolic links are enabled. To do so without enabling
   Developer Mode, open **Local Group Policy Editor** and add my username to
   `Computer Configuration` > `Windows Settings` > `Security Settings` > `Local
   Policies` > `User Rights Assignment` > `Create symbolic links`.

2. [Install](https://www.chezmoi.io/install/) chezmoi.

    - macOS: `brew install chezmoi`
    - Ubuntu: `sudo snap install chezmoi --classic`
    - Windows: `scoop install chezmoi`

On machines where I use a Git credential manager:

3. `chezmoi init --apply marktsuchida` (uses HTTPS)

On machines where I use SSH for Git:

3. `ssh-keygen -t ed25519 -a 100` (with passphrase)

4. Add `~/.ssh/id_ed25519.pub` to GitHub.

5. `chezmoi init --apply --ssh marktsuchida`

## Manual settings

### Mapping Caps Lock to Ctrl

- On Windows, use Microsoft PowerToys > Keyboard Manager.
