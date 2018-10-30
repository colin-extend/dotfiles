# eval "$(rbenv init -)"

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

export PATH="$HOME/.cargo/bin:$PATH"
BLURB_DEV_ROOT="$HOME/dev" # this is where all your blurb repos are
source "$BLURB_DEV_ROOT/web-scripts/profile-scripts" # this lets you use cdd to quickly navigate relative to BLURB_DEV_ROOT, and use the completions
PATH="$PATH:$BLURB_DEV_ROOT/web-scripts" # this adds all the commands to your PATH so you can call them from anywhere
