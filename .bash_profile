#!/bin/bash
if [ -f "${HOME}/.bash_profile_lcruz" ] ; then
  source "${HOME}/.bash_profile_lcruz"
fi

HISTFILESIZE=100000
HISTSIZE=10000
PROMPT_COMMAND="history -a"

shopt -s histappend
