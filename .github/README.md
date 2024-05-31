# dotfiles

Setting up with [chezmoi](https://www.chezmoi.io/):

1. [Install](https://www.chezmoi.io/install/) chezmoi.

    - macOS: Homebrew
    - Ubuntu: Snap
    - Windows: Chocolatey

2. `chezmoi init https://github.com/marktsuchida/dotfiles.git`

Or, on machines where I use SSH for Git:

1. `ssh-keygen -t ed25519 -a 100`

2. Add `~/.ssh/id_ed25519.pub` to GitHub.

3. `chezmoi init git@github.com:marktsuchida/dotfiles.git`
