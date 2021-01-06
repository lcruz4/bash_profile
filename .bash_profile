#!/bin/bash
if [ -f "${HOME}/.bash_profile_lcruz" ] ; then
  source "${HOME}/.bash_profile_lcruz"
fi
if [ -f "${HOME}/.git-prompt.sh" ] ; then
  source "${HOME}/.git-prompt.sh"
fi

export PS1='\[\033[32m\]\u@\h:\[\033[33m\]\w\[\033[36m\]`__git_ps1`\[\033[00m\] \$ '
