# Dotfiles

## Installation

1. Clone the repository and initialize submodules:

   ```bash
   git clone git@github.com:leonardcser/.dotfiles.git
   cd .dotfiles
   git submodule update --init --recursive
   ```

2. Open a new zsh shell — [zinit](https://github.com/zdharma-continuum/zinit) will automatically install plugins on first run.

## Maintenance

To update the `Brewfile`:

```bash
brew bundle dump --file=Brewfile --describe --force
```

To sync the `Brewfile`:

```bash
brew bundle --file=Brewfile --force cleanup
```
