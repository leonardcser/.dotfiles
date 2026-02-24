# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# OS Detection
if [[ "$OSTYPE" == "darwin"* ]]; then
  export OS_TYPE="macos"
else
  export OS_TYPE="linux"
fi

# Editor
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# --- Zinit ---
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [[ ! -d "$ZINIT_HOME" ]]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"

# Theme
zinit ice depth=1
zinit light romkatv/powerlevel10k

# Vi mode
function zvm_config() {
  ZVM_CURSOR_STYLE_ENABLED=false
  ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT
}
zinit ice depth=1
zinit light jeffreytse/zsh-vi-mode

function zvm_after_init() {
  # fzf
  local _cache="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/fzf.zsh"
  [[ -f "$_cache" ]] && source "$_cache"
  export FZF_DEFAULT_COMMAND='find . \( -name node_modules -o -name vendor -o -name .bundle -o -name .git -o -name .venv -o -name venv -o -name env -o -name __pycache__ -o -name .pytest_cache -o -name .mypy_cache -o -name .ruff_cache -o -name build -o -name dist -o -name target -o -name out -o -name coverage -o -name .svelte-kit -o -name .next -o -name .turbo -o -name .nuxt -o -name .zig-cache -o -name .cargo -o -name .gradle -o -name .expo -o -name .expo-shared -o -name .vscode -o -name .cursor -o -name .idea -o -name .oh-my-zsh -o -name .cache -o -name .wrangler -o -name .github -o -name tmp \) -prune -o ! -name .DS_Store -print'
  alias tx=tmux-sessionizer
  bindkey -s '^F' 'tx\n'
}

# Plugins (turbo-loaded)
zinit wait lucid for \
  atload"_zsh_autosuggest_start" zsh-users/zsh-autosuggestions \
  zsh-users/zsh-syntax-highlighting \
  OMZP::colored-man-pages \
  OMZP::colorize

# --- Shell options ---
DISABLE_AUTO_TITLE="true"
setopt PRINT_EXIT_VALUE
unsetopt PROMPT_SP

# Prompt
MODE_INDICATOR="%F{white}-%f"
INSERT_MODE_INDICATOR="%F{cyan}+%f"
PROMPT="\$(vi_mode_prompt_info)$PROMPT"
RPROMPT=""
VIRTUAL_ENV_DISABLE_PROMPT=

# History
setopt HIST_EXPIRE_DUPS_FIRST HIST_IGNORE_DUPS HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE HIST_FIND_NO_DUPS HIST_SAVE_NO_DUPS

# --- Environment ---
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export HOMEBREW_NO_INSECURE_REDIRECT=1
export NODE_EXTRA_CA_CERTS="$HOME/.local/share/ca-certificates.pem"
export CPATH="/usr/local/include:$CPATH"
export LIBRARY_PATH="/usr/local/lib:$LIBRARY_PATH"
export LD_LIBRARY_PATH="$HOME/.local/lib:$LD_LIBRARY_PATH"
export CMAKE_EXPORT_COMPILE_COMMANDS=ON
export ANDROID_HOME="$HOME/Library/Android/sdk"

# --- Static tool inits (auto-generate if missing) ---
_zsh_cache="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
[[ -d "$_zsh_cache" ]] || mkdir -p "$_zsh_cache"

if [[ ! -f "$_zsh_cache/fzf.zsh" ]] && (( $+commands[fzf] )); then
  fzf --zsh > "$_zsh_cache/fzf.zsh"
fi
if [[ ! -f "$_zsh_cache/zoxide.zsh" ]] && (( $+commands[zoxide] )); then
  zoxide init zsh > "$_zsh_cache/zoxide.zsh"
fi
if [[ ! -f "$_zsh_cache/mise.zsh" ]] && (( $+commands[mise] )); then
  mise activate zsh > "$_zsh_cache/mise.zsh"
fi

# Source cached inits (fzf is sourced in zvm_after_init instead)
[[ -f "$_zsh_cache/zoxide.zsh" ]] && source "$_zsh_cache/zoxide.zsh"
[[ -f "$_zsh_cache/mise.zsh" ]] && source "$_zsh_cache/mise.zsh"

unset _zsh_cache

# GPG (deferred to avoid tty fork at startup)
_gpg_tty_init() { export GPG_TTY=$(tty); }
precmd_functions+=(_gpg_tty_init)

# --- PATH ---
export PATH="${PATH}:${HOME}/.local/bin"
export PATH="${PATH}:${HOME}/.local/bin/scripts"
export PATH="${PATH}:/usr/local/sbin"
export PATH="$PATH:$HOME/go/bin"
[[ $OS_TYPE == "macos" ]] && export PATH="$PATH:/opt/homebrew/opt/rustup/bin"
export PATH="$PATH:$HOME/.cargo/bin"
export PATH="$PATH:$ANDROID_HOME/platform-tools:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin"

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

export PATH="$PATH:$HOME/.lmstudio/bin"

# --- Aliases ---
alias zshconfig="nvim ~/.zshrc"
alias ls="ls -1lh --color=auto"
alias ll="ls -1alh --color=auto"
alias claude="command claude --allow-dangerously-skip-permissions"
alias code="codium"
alias clear="clear && printf '\e[3J'"
alias cpwd="pwd | tr -d '\n' | pbcopy"
alias nv="nvim"
alias .="nvim ."
alias vi="vim"
alias sloc="wc -l **/*.*"

# --- Functions ---
clrhist() {
    echo "" > ~/.zsh_history & exec $SHELL -l
}

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

mycommands() {
    cat <<"EOF"
MY CUSTOM COMMANDS.........................................
-  zshconfig      Open ~/.zshrc in nvim
-  f              Open finder in current dir
-  cdf            cd to opened finder window
-  nv             Alias for nvim
-  .              Open nvim in current directory
-  tx             Alias for tmux-sessionizer
-  sloc           Count lines of code
-  clrhist        Clear terminal history
-  kill-apps      Kill all running processes matching pattern
-  pdwatch        Watch for changes with pandoc
-  mycommands     Show this help menu
EOF
}

# macOS-specific
if [[ $OS_TYPE == "macos" ]]; then
  cdf() {
      target=`osascript -e 'tell application "Finder" to if (count of Finder windows) > 0 then get POSIX path of (target of front Finder window as text)'`
      if [ "$target" != "" ]; then
          cd "$target"; pwd
      else
          echo 'No Finder window found' >&2
      fi
  }
  alias f='open -a Finder ./'
  pdwatch() { /Users/leo/dev/go/pdwatch/pdwatch $@; }
fi

# --- Env file ---
[ -f "$HOME/.env.term" ] && source "$HOME/.env.term"

# Powerlevel10k config
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
