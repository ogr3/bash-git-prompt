#!/bin/bash

# Exports a prefix to the bash-git-prompt using GIT_PROMPT_START 
# that truncates pwd to a max length depending on the terminal column width. 
# Also uses the prompt_callback function of bash-git-promot to set the 
# window title
#
# https://github.com/magicmonty/bash-git-prompt
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
