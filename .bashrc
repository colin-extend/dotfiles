
source ~/.bash_aliases
source ~/.git-prompt.sh
source ~/.git-completion.bash

GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true
GIT_PS1_SHOWCOLORHINTS=true
PROMPT_COMMAND='__git_ps1 "\033[1;33m------------------------------------------------\033[0m\n\D{%F %T}\n\u@\h:\w " "\n\\\$ "'

alias l='ls --color'
LS_COLORS='di=1:fi=0:ln=31:pi=5:so=5:bd=5:cd=5:or=31:mi=0:ex=35:*.rpm=90'
export LS_COLORS
export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting