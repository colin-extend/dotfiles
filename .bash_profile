source ~/.profile
source ~/.bash_aliases
source ~/.untracked_vars
source ~/.bashrc

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
#.base_terminal - Shortcuts and Bash Utilities - https://github.com/ashoda/.base_terminal.git
# source ~/.base_terminal/base.sh
export PATH="$PATH:~/bin"
# ############################################

# # Modified from emilis bash prompt script

# # from https://github.com/emilis/emilis-config/blob/master/.bash_ps1

# #

# # Modified for Mac OS X by

# # @corndogcomputer

# ###########################################
# # Fill with minuses

# # (this is recalculated every time the prompt is shown in function prompt_command):

# fill="--- "

# reset_style='\[\033[00m\]'

# status_style=$reset_style'\[\033[0;90m\]' # gray color; use 0;37m for lighter color

# prompt_style=$reset_style

# command_style=$reset_style'\[\033[1;29m\]' # bold black

# # Prompt variable:

# PS1="$status_style"'$fill \t\n'"$prompt_style"'${debian_chroot:+($debian_chroot)}\u@\h:\w\$'"$command_style "

# # Reset color for command output

# # (this one is invoked every time before a command is executed):

# trap 'echo -ne "\033[00m"' DEBUG

# function prompt_command {

# # create a $fill of all screen width minus the time string and a space:

# let fillsize=${COLUMNS}-9

# fill=""

# while [ "$fillsize" -gt "0" ]

# do

# fill="-${fill}" # fill with underscores to work on

# let fillsize=${fillsize}-1

# done

# # If this is an xterm set the title to user@host:dir

# case "$TERM" in

# xterm*|rxvt*)

# bname=`basename "${PWD/$HOME/~}"`

# echo -ne "\033]0;${bname}: ${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"

# ;;

# *)

# ;;

# esac

# }

# PROMPT_COMMAND=prompt_command

##
# Finished adapting your PATH environment variable for use with MacPorts.
export PATH="$PATH:/usr/local/sbin"
# Setting PATH for Python 2.7
# The orginal version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/2.7/bin:${PATH}"
export PATH

export PATH="$PATH:/Users/colincahill/Library/Python/2.7/bin"

##
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
# Finished adapting your PATH environment variable for use with MacPorts.

##
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
# Finished adapting your PATH environment variable for use with MacPorts.
export GOPATH=$HOME/work/go
# Setting PATH for Python 3.5
# The original version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.5/bin:${PATH}"
export PATH

# MacPorts Installer addition on 2016-12-25_at_02:37:41: adding an appropriate PATH variable for use with MacPorts.
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
# Finished adapting your PATH environment variable for use with MacPorts.

export JAVA_HOME=$(/usr/libexec/java_home)
export PATH="$PATH:/usr/local/browsermob-proxy-2.1.3/bin"
export PATH="$PATH:/usr/local/apache-maven-3.3.9/bin"
export NVM_DIR="$HOME/.nvm"
export PGUSER="ccahill"
. "/usr/local/opt/nvm/nvm.sh"


[[ -s "$HOME/.avn/bin/avn.sh" ]] && source "$HOME/.avn/bin/avn.sh" # load avn
