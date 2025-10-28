# Dotfiles

## Installation

1. Clone the repository and initialize submodules:

   ```bash
   git clone git@github.com:leonardcser/.dotfiles.git
   cd .dotfiles
   git submodule update --init --recursive
   ```

2. Install Oh My Zsh custom theme & plugins:

   ```bash
   # Theme
   git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
     .oh-my-zsh/custom/themes/powerlevel10k

   # Plugins
   git clone https://github.com/jeffreytse/zsh-vi-mode.git \
     .oh-my-zsh/custom/plugins/zsh-vi-mode

   git clone https://github.com/romkatv/zsh-defer.git \
     .oh-my-zsh/custom/plugins/zsh-defer

   git clone https://github.com/zsh-users/zsh-autosuggestions.git \
     .oh-my-zsh/custom/plugins/zsh-autosuggestions

   git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
     .oh-my-zsh/custom/plugins/zsh-syntax-highlighting
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
