# Dotfiles

## Installation

1. Clone the repository and initialize submodules:

   ```bash
   git clone git@github.com:leonardcser/.dotfiles.git
   cd .dotfiles
   git submodule update --init --recursive
   ```

2. Open a new zsh shell — [zinit](https://github.com/zdharma-continuum/zinit) will automatically install plugins on first run.

## Secrets

Secrets are stored in macOS Keychain and exported as environment variables on shell startup.

```bash
# Add a new secret
echo "MY_SECRET_KEY" >> ~/.secrets-keys
read -s "?Value: " val && security add-generic-password -a "$USER" -s "MY_SECRET_KEY" -w "$val" -U; unset val
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
