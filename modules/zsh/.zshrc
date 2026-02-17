#zmodload zsh/zprof

ZSH_COMPDUMP="${ZDOTDIR:-$HOME}/.zcompdump"

if [[ -n "$ZSH_COMPDUMP"(#qN.m-1) ]]; then
  compinit -C -d "$ZSH_COMPDUMP"
else
  compinit -d "$ZSH_COMPDUMP"
fi

{
  if [[ -s "$ZSH_COMPDUMP" && (! -s "${ZSH_COMPDUMP}.zwc" || "$ZSH_COMPDUMP" -nt "${ZSH_COMPDUMP}.zwc") ]]; then
    zcompile "$ZSH_COMPDUMP"
  fi
} &!

() {
  setopt local_options NULL_GLOB
  local f
  for f in "${ZDOTDIR:-$HOME}/functions/"*.sh; do
    source "$f"
  done
}

# --- Aliases ---
alias q="exit"
alias l="ls -CF"
alias ll="ls -lSh"
alias la="ls -A"
alias cl="clear"
alias open="xdg-open"
alias docker="podman"

HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

setopt PROMPT_SUBST
PROMPT='%F{green}%*%f %F{blue}%~%f $ '

#zprof
