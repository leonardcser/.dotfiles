# Slow startup detection — dumps zprof trace when startup exceeds 2s
zmodload zsh/datetime
_zshrc_start=$EPOCHREALTIME
_zsh_slow_check() {
  local elapsed=$(( EPOCHREALTIME - _zshrc_start ))
  if (( elapsed > 2 )); then
    local dump="/tmp/zsh-slow-startup-$(date +%Y%m%d-%H%M%S).log"
    {
      echo "Slow startup detected: ${elapsed}s at $(date)"
      echo "PWD: $PWD"
      echo "---"
      zprof
    } > "$dump"
    echo "\e[33m[zsh] Slow startup (${elapsed}s) — trace dumped to $dump\e[0m"
  fi
  precmd_functions=(${precmd_functions:#_zsh_slow_check})
  unset _zshrc_start
}
zmodload zsh/zprof
precmd_functions=(_zsh_slow_check $precmd_functions)

# OS Detection
if [[ "$OSTYPE" == "darwin"* ]]; then
  export OS_TYPE="macos"
else
  export OS_TYPE="linux"
  (( $+commands[fdfind] )) && alias fd=fdfind
fi

# Load the signing key into the local agent, never into a forwarded agent.
if [[ -o interactive && $OSTYPE == linux* && -n ${XDG_RUNTIME_DIR:-} &&
      $SSH_AUTH_SOCK == "$XDG_RUNTIME_DIR/openssh_agent" && -S $SSH_AUTH_SOCK &&
      -r ~/.ssh/id_ed25519 && -r ~/.ssh/id_ed25519.pub ]]; then
  if ! ssh-add -L | awk 'NR == 1 { key = $2; next } $2 == key { found = 1 } END { exit !found }' ~/.ssh/id_ed25519.pub -; then
    ssh-add -q ~/.ssh/id_ed25519
  fi
fi

# Editor
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

bindkey -v

# --- Shell options ---
DISABLE_AUTO_TITLE="true"
setopt AUTO_CD
setopt PRINT_EXIT_VALUE
unsetopt PROMPT_SP

# Completion
# zmodload zsh/complist
# autoload -Uz compinit
# if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
#   compinit
# else
#   compinit -C
# fi
# zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
# zstyle ':completion:*' menu select
# zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'

# The prompt displays the venv itself; don't let activate prepend it again.
export VIRTUAL_ENV_DISABLE_PROMPT=1

# History
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
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

# --- Tool inits (cached via evalcache) ---
source "${HOME}/.config/zsh/plugins/evalcache.plugin.zsh"

# Shims select the project's tool version without running a prompt hook.
_mise_shims=${MISE_DATA_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/mise}/shims
if [[ -d $_mise_shims ]]; then
  path=("$_mise_shims" "${(@)path:#$_mise_shims}")
fi
unset _mise_shims

whence -p fzf &>/dev/null && _evalcache fzf --zsh
export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
export FZF_CTRL_T_COMMAND='fd --type d --hidden --exclude .git'
alias tx=tmux-sessionizer
bindkey -s '^F' 'tx\n'
(( $+commands[zoxide] )) && _evalcache zoxide init zsh
(( $+commands[direnv] )) && _evalcache direnv hook zsh

# Use the controlling terminal directly; keep the stdin probe as a fallback.
if [[ -n $TTY ]]; then
  export GPG_TTY=$TTY
else
  _gpg_tty_init() { export GPG_TTY=$(tty); }
  precmd_functions+=(_gpg_tty_init)
fi

# --- Aliases ---
alias zshconfig="nvim ~/.zshrc"
alias ls="ls -1lh --color=auto"
alias ll="ls -1alh --color=auto"
alias claude="command claude --allow-dangerously-skip-permissions"
alias code="codium"
alias clear="clear && printf '\e[3J'"
alias nv="nvim"
alias .="nvim ."
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."
alias vi="vim"
alias md="mkdir"
alias sloc="wc -l **/*.*"

# --- Functions ---
osc52_copy() {
  local encoded
  if (( $# > 0 )); then
    encoded=$(printf "%s" "$*" | base64 | tr -d "\n")
  else
    encoded=$(base64 | tr -d "\n")
  fi
  printf "\033]52;c;%s\a" "$encoded"
}

cpwd() {
  osc52_copy "$PWD"
  printf "Copied: %s\n" "$PWD"
}

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

# --- On-demand macOS Keychain credentials ---
if [[ $OS_TYPE == macos ]]; then
  with-secret() {
    emulate -L zsh
    unsetopt xtrace
    if (( $# < 2 )) || [[ $1 != [A-Z_]* || $1 == *[^A-Z0-9_]* ]]; then
      print -u2 'usage: with-secret KEY executable [args...]'
      return 2
    fi
    local key=$1 value
    shift
    value=${(P)key}
    if [[ -z $value ]]; then
      value=$(command security find-generic-password -a "$USER" -s "$key" -w) || return 1
    fi
    local -x "$key=$value"
    command "$@"
  }
fi

# Machine-local settings
[[ ! -f ~/.zshrc.local ]] || source ~/.zshrc.local

source "$HOME/.config/zsh/prompt.zsh"

# bun completions
[ -s "${BUN_INSTALL:-$HOME/.bun}/_bun" ] && source "${BUN_INSTALL:-$HOME/.bun}/_bun"

# History suggestions must work on the very first command.
_zsh_plugins=${XDG_DATA_HOME:-$HOME/.local/share}/zinit/plugins
_suggest=$_zsh_plugins/zsh-users---zsh-autosuggestions/zsh-autosuggestions.zsh
[[ ! -r $_suggest ]] || source "$_suggest"

_load_idle_highlight() {
  (( PENDING || KEYS_QUEUED_COUNT )) && return 0
  zle -F "$1"
  exec {_highlight_fd}<&-
  : ${FAST_WORK_DIR:=${XDG_CACHE_HOME:-$HOME/.cache}/fsh}
  source "$_idle_highlight_script" || return
  unset _idle_highlight_script
  # Rewrap the new editing widgets and color the current line without a keystroke.
  (( $+functions[_zsh_autosuggest_start] )) && _zsh_autosuggest_start
  _zsh_highlight
  (( $+functions[_zsh_autosuggest_highlight_apply] )) && _zsh_autosuggest_highlight_apply
  zle -R
}
_arm_idle_highlight() {
  add-zle-hook-widget -d line-init _arm_idle_highlight
  # A one-shot timer wakes ZLE; the shell does not wait for it to draw the prompt.
  exec {_highlight_fd}< <(command sleep 0.1)
  zle -F -w "$_highlight_fd" _load_idle_highlight
}
_idle_highlight_script=$_zsh_plugins/zdharma-continuum---fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
if [[ -r $_idle_highlight_script ]] && (( ! $+functions[_zsh_highlight] )); then
  autoload -Uz add-zle-hook-widget
  zle -N _load_idle_highlight
  add-zle-hook-widget line-init _arm_idle_highlight
fi
unset _zsh_plugins _suggest
