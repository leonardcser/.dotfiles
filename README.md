# Dotfiles

## Usage

1. `./deploy.sh MANIFEST`
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

## Other

```bash
# Theme
git submodule add https://github.com/romkatv/powerlevel10k.git \
  .oh-my-zsh/custom/themes/powerlevel10k

# Plugins
git submodule add https://github.com/jeffreytse/zsh-vi-mode.git \
  .oh-my-zsh/custom/plugins/zsh-vi-mode

git submodule add https://github.com/romkatv/zsh-defer.git \
  .oh-my-zsh/custom/plugins/zsh-defer

git submodule add https://github.com/zsh-users/zsh-autosuggestions.git \
  .oh-my-zsh/custom/plugins/zsh-autosuggestions

git submodule add https://github.com/zsh-users/zsh-syntax-highlighting.git \
  .oh-my-zsh/custom/plugins/zsh-syntax-highlighting
```
