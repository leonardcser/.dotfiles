# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(vi-mode)

source $ZSH/oh-my-zsh.sh
source $ZSH/custom/plugins/zsh-defer/zsh-defer.plugin.zsh # zsh-defer

source $ZSH/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
source $ZSH/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh
source $ZSH/plugins/colored-man-pages/colored-man-pages.plugin.zsh
source $ZSH/plugins/colorize/colorize.plugin.zsh

# USER CONFIGURATION
# prompt
MODE_INDICATOR="%F{white}-%f"
INSERT_MODE_INDICATOR="%F{cyan}+%f"
# PROMPT="\$(vi_mode_prompt_info)%30<...<%}$PROMPT%<<%}"
PROMPT="\$(vi_mode_prompt_info)$PROMPT"
RPROMPT=""
setopt PRINT_EXIT_VALUE

# export MANPATH="/usr/local/man:$MANPATH"
VIRTUAL_ENV_DISABLE_PROMPT=
# https://superuser.com/questions/645599/why-is-a-percent-sign-appearing-before-each-prompt-on-zsh-in-windows
unsetopt PROMPT_SP


# history
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS

# You may need to manually set your language environment
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# Security
HOMEBREW_NO_INSECURE_REDIRECT=1

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
alias zshconfig="nvim ~/.zshrc"
alias ohmyzsh="nvim ~/.oh-my-zsh"

alias ls="ls -1lh --color=auto"
alias ll="ls -1alh --color=auto"
alias code="codium"

# Neovim aliasas
alias nv="nvim"
alias .="nvim ."
alias vi="vim"

# fzf
source <(fzf --zsh)
export FZF_DEFAULT_COMMAND='find . \( -name node_modules -o -name .git -o -name .venv -o -name build \) -prune -o -print'
alias tx=~/.local/bin/scripts/tmux-sessionizer
bindkey -s '^F' 'tx\n'

# PERSONAL FUNCTIONS
# Shortcut Function
cdf() {
    target=`osascript -e 'tell application "Finder" to if (count of Finder windows) > 0 then get POSIX path of (target of front Finder window as text)'`
    if [ "$target" != "" ]; then
        cd "$target"; pwd
    else
        echo 'No Finder window found' >&2
    fi
}

# Prevent from perm. delete
# alias rm=trash

# Open finder
alias f='open -a Finder ./'

# Count lines of code
alias sloc="wc -l **/*.*"

clrhist() {
    echo "" > ~/.zsh_history & exec $SHELL -l
}

# Kill apps that match string
kill-apps() {
  IFS=$'\n'
  red=$(tput setaf 1)
  normal=$(tput sgr0)
  if [ -z "$1" ] || [ "$1" = "--help" ]; then
    printf "%s\n" "Usage: kill-apps string"
    return 0
  fi
  printf "%s\n" "Finding apps that match "'$1'"…"
  sleep 1
  processes=($(pgrep -afil "$1"))
  if [ ${#processes[@]} -eq 0 ]; then
    printf "%s\n" "No apps found"
    return 0
  else
    printf "%s\n" "${processes[@]}"
    printf "$red%s$normal" "Kill found apps (y or n)? "
    read -r answer
    if [ "$answer" = "y" ]; then
      printf "%s\n" "Killing found apps…"
      sleep 1
      for process in "${processes[@]}"; do
        echo $process | awk '{print $1}' | xargs sudo kill 2>&1 | grep -v "No such process"
      done
      printf "%s\n" "Done"
      return 0
    fi
  fi
}

pdwatch() {
    /Users/leo/dev/go/pdwatch/pdwatch $@
}

# Help to remember list of my commands
mycommands() {
    cat <<"EOF"
MY CUSTOM COMMANDS.........................................
-  zshconfig      Open config in VSCode
-  ohmyzshconfig  Open config in VSCode
-  f              Open finder in current dir
-  cdf            cd opened finder window
-  sloc           Count lines of code (git)
-  clrhist        Clear Terminal History
-  kill-apps      Kills all running processes with grep
-  pdwatch        Watch for changes with pandoc
EOF
}

# bin paths
export PATH="${PATH}:${HOME}/.local/bin"
export PATH="${PATH}:/usr/local/sbin"

# Python
if command -v pyenv 1>/dev/null 2>&1; then
  zsh-defer eval "$(pyenv init -)"
fi
export PATH=$HOME/.pyenv/shims:$PATH

# nvm
export NVM_DIR="$HOME/.nvm"
zsh-defer source "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
zsh-defer source "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# c/cpp
# CC=/usr/local/bin/gcc-14
export CPATH="/usr/local/include:$CPATH"
export LIBRARY_PATH="/usr/local/lib:$LIBRARY_PATH"

# cmake
export CMAKE_EXPORT_COMPILE_COMMANDS=ON

# GPG
export GPG_TTY=$(tty)

# go
export PATH=$PATH:$HOME/go/bin

# rust
export PATH=$PATH:/opt/homebrew/opt/rustup/bin
export PATH=$PATH:$HOME/.cargo/bin

# java
export SDKMAN_DIR="$HOME/.sdkman"
zsh-defer source "$HOME/.sdkman/bin/sdkman-init.sh"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

