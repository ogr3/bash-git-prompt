#!/bin/bash

# Exports a prefix to the bash-git-prompt using GIT_PROMPT_START
# that truncates pwd to a max length depending on the terminal column width.
# Also uses the prompt_callback function of bash-git-prompt to set the
# window title
#
# The prefix will use a Debian-style prompt on the form
# [user@host: <truncated PWD>]
#
# Just source this file in addiion to gitprompt.sh to activate.
#
# Upstream: https://github.com/magicmonty/bash-git-prompt
# This repo: https://github.com/ogr3/bash-git-prompt
#
# Add to .bashrc:
#
# if [ -f ~/.bash-git-prompt/gitprompt.sh ] &&  [ -f ~/.bash-git-prompt/git-prompt-prefix.sh ]; then
#  source ~/.bash-git-prompt/git-prompt-prefix.sh
#  source ~/.bash-git-prompt/gitprompt.sh
# fi
#
# oGre <oGre@muppfarmen.se> [http://github.com/ogr3]

#Sets the window title to the given argument string
function set_title {
  echo -ne "\033]0;"$@"\007"
}

#Overrides the prompt_callback function used by bash-git-prompt
function prompt_callback {
  PS1="\u@\h: ${newPWD}"
  set_title $PS1
}

#Helper function that truncates $PWD depending on window width
function truncate_pwd {
  newPWD="${PWD/#$HOME/~}"
  local pwdmaxlen=$((${COLUMNS:-80}/3))
  [ ${#newPWD} -gt $pwdmaxlen ] && newPWD="...${newPWD:3-$pwdmaxlen}"
}

PROMPT_COMMAND=truncate_pwd

case "$TERM" in
  xterm*|rxvt*)
export GIT_PROMPT_START="\[\033[0;33m\][\u@\h: \${newPWD}]\[\033[0m\]"
;;
*)
;;
esac
