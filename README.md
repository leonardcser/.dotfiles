# Dotfiles

## Usage

1. Install xcode tools
2. Install brew + taps
3. Install zsh custom plugins
4. `./deploy.sh MANFIEST`

## Mantainence

To update the `Brewfile`:

```bash
brew bundle dump
```

## Additional dependencies

```bash
npm install -g @fsouza/prettierd
```

## MacOS

```bash
# "Disable" dock
defaults write com.apple.dock autohide-delay -float 1000; killall Dock
```
