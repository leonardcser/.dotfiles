# Dotfiles

## Usage

1. Install xcode tools
2. Install brew + taps
3. Install zsh custom plugins
4. `./deploy.sh MANFIEST`
5. `./post.sh`

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
# Allow to drag windows from anywhere by holding ctrl+cmd (not working)
defaults write -g NSWindowShouldDragOnGesture -bool true
```
