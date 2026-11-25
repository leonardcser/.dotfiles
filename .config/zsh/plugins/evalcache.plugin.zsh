# Caches the output of a binary initialization command, to avoid the time to
# execute it in the future.
#
# Usage: _evalcache [NAME=VALUE]... COMMAND [ARG]...

# default cache directory
export ZSH_EVALCACHE_DIR=${ZSH_EVALCACHE_DIR:-"$HOME/.zsh-evalcache"}

function _evalcache () {
  local cmdHash="nohash" data="$*" name

  # use the first non-variable argument as the name
  for name in $@; do
    if [ "${name}" = "${name#[A-Za-z_][A-Za-z0-9_]*=}" ]; then
      break
    fi
  done

  # if command is a function, include its definition in data
  if typeset -f "${name}" > /dev/null; then
    data=${data}$(typeset -f "${name}")
  fi

  # These MD5s keep existing cache files usable without forking on the hot path.
  case "$data" in
    'zoxide init zsh')   cmdHash=dd15fbbae9cb3276f5c4139e43392f81 ;;
    'mise activate zsh') cmdHash=8d6a6bfdd12dbe9cb7cb2af5f3fb92a3 ;;
    'direnv hook zsh')   cmdHash=c24b0a2617cfac5ba87229adccd1eb40 ;;
    'fzf --zsh')         cmdHash=3bac096bc498334848f27470d2e2fe45 ;;
    *)
      if builtin command -v md5 > /dev/null; then
        cmdHash=$(echo -n "${data}" | md5)
      elif builtin command -v md5sum > /dev/null; then
        cmdHash=$(echo -n "${data}" | md5sum | cut -d' ' -f1)
      fi ;;
  esac

  local cacheFile="$ZSH_EVALCACHE_DIR/init-${name##*/}-${cmdHash}.sh"

  if [ "$ZSH_EVALCACHE_DISABLE" = "true" ]; then
    eval ${(q)@}
  elif [ -s "$cacheFile" ]; then
    source "$cacheFile"
  else
    if type "${name}" > /dev/null; then
      echo "evalcache: ${name} initialization not cached, caching output of: $*" >&2
      mkdir -p "$ZSH_EVALCACHE_DIR"
      eval ${(q)@} > "$cacheFile"
      zcompile "$cacheFile"
      source "$cacheFile"
    else
      echo "evalcache: ERROR: ${name} is not installed or in PATH" >&2
    fi
  fi
}

function _evalcache_clear () {
  rm -i "$ZSH_EVALCACHE_DIR"/init-*.{sh,zwc}
}
