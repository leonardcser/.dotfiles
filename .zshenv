# PATH (sourced for all zsh sessions, including non-interactive SSH commands)
export PATH="$HOME/.local/bin:$HOME/.local/bin/scripts:$PATH"
export PATH="$PATH:/usr/local/sbin"
export PATH="$PATH:$HOME/go/bin"
export PATH="$PATH:$HOME/.cargo/bin"

if [[ "$OSTYPE" == "darwin"* ]]; then
  export PATH="$PATH:/opt/homebrew/opt/rustup/bin"
  export ANDROID_HOME="$HOME/Library/Android/sdk"
  export PATH="$PATH:$ANDROID_HOME/platform-tools:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin"
  export PNPM_HOME="$HOME/Library/pnpm"
  case ":$PATH:" in
    *":$PNPM_HOME:"*) ;;
    *) export PATH="$PNPM_HOME:$PATH" ;;
  esac
  export PATH="$PATH:$HOME/.lmstudio/bin"
fi
