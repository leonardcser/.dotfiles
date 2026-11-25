# Dotfiles

## Installation

1. Clone the repository and initialize submodules:

   ```bash
   git clone git@github.com:leonardcser/.dotfiles.git
   cd .dotfiles
   git submodule update --init --recursive
   ```

2. Symlink the Linux dotfiles:

   ```bash
   ./deploy.sh MANIFEST.linux
   ```

3. Open a new zsh shell — [zinit](https://github.com/zdharma-continuum/zinit)
   will automatically install plugins on first run.

## Secrets

On macOS, store a key once, then use `with-secret` to give it to one command:

```zsh
security add-generic-password -U -a "$USER" -s BOX_API_KEY -w
with-secret BOX_API_KEY smelt
```

## Maintenance

To update the `Brewfile`:

```bash
brew bundle dump --file=Brewfile --describe --force
```

To sync the `Brewfile`:

```bash
brew bundle --file=Brewfile --force cleanup
```
