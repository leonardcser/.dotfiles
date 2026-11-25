# Prompt values in psvar render literally, even if a branch or venv contains '%'.
PROMPT='%3(V.%F{37}(%3v%)%f .)%B%F{39}%~%f%b%1(V. %F{76}%1v%f.)'$'\n''%(?.%F{76}.%F{196})%2v%f '
RPROMPT=''

_fast_prompt_update() {
  local head
  # Ask Git to locate HEAD only on directory changes (also handles worktrees).
  if [[ $PWD != $_fast_prompt_dir || ( -z $_fast_prompt_head && -e .git ) ]]; then
    _fast_prompt_dir=$PWD
    _fast_prompt_head=$(command git rev-parse --git-path HEAD 2>/dev/null) || _fast_prompt_head=''
  fi
  psvar[1]=''
  if [[ -r $_fast_prompt_head ]] && IFS= read -r head < "$_fast_prompt_head"; then
    case $head in
      'ref: refs/heads/'*) psvar[1]=${head#ref: refs/heads/} ;;
      *) psvar[1]=${head[1,7]} ;;
    esac
  fi
  psvar[2]='>'
  psvar[3]=${VIRTUAL_ENV:t}
}

_fast_prompt_keymap() {
  case $KEYMAP in
    vicmd) psvar[2]='<' ;;
    *) psvar[2]='>' ;;
  esac
  zle reset-prompt
}

autoload -Uz add-zsh-hook add-zle-hook-widget
add-zsh-hook precmd _fast_prompt_update
add-zle-hook-widget keymap-select _fast_prompt_keymap
