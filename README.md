# Dotfiles

## Usage

1. `./deploy.sh MANFIEST`
2. `./install.sh`
3. Install zsh custom plugins

## Mantainence

To update the `Brewfile`:

```bash
brew bundle dump --file=Brewfile --describe --force
```

To sync the `Brewfile`:

```bash
brew bundle --file=Brewfile --force cleanup
```
