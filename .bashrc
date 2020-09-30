source ~/.bash_aliases
source ~/.git-prompt.sh
source ~/.git-completion.bash

# eval "$(direnv hook bash)"

DOTIFLES_DIR=$(pwd)
GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true
GIT_PS1_SHOWCOLORHINTS=true
PROMPT_COMMAND='__git_ps1 "\033[1;33m------------------------------------------------\033[0m\n\D{%F %T}\n\u@\h:\w " "\n\\\$ "'

alias l='ls --color'
LS_COLORS='di=1:fi=0:ln=31:pi=5:so=5:bd=5:cd=5:or=31:mi=0:ex=35:*.rpm=90'
export LS_COLORS

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

eval "$(hub alias -s)"

find-up() {
    path=$(pwd)
    while [[ $path != "" && ! -e "$path/$1" ]]; do
        path=${path%/*}
    done
    echo "$path"
}

cdnvm() {
    cd "$@"
    nvm_path=$(find-up .nvmrc | tr -d '[:space:]')

    # If there are no .nvmrc file, use the default nvm version
    if [[ $nvm_path != *[^[:space:]]* ]]; then

        declare default_version
        default_version=$(nvm version default)

        # If there is no default version, set it to `node`
        # This will use the latest version on your machine
        if [[ $default_version == "N/A" ]]; then
            nvm alias default node
            default_version=$(nvm version default)
        fi

        # If the current version is not the default version, set it to use the default version
        if [[ $(nvm current) != "$default_version" ]]; then
            nvm use default
        fi

    elif [[ -s $nvm_path/.nvmrc && -r $nvm_path/.nvmrc ]]; then
        declare nvm_version
        nvm_version=$(< "$nvm_path"/.nvmrc)

        declare locally_resolved_nvm_version
        # `nvm ls` will check all locally-available versions
        # If there are multiple matching versions, take the latest one
        # Remove the `->` and `*` characters and spaces
        # `locally_resolved_nvm_version` will be `N/A` if no local versions are found
        locally_resolved_nvm_version=$(nvm ls --no-colors "$nvm_version" | tail -1 | tr -d '\->*' | tr -d '[:space:]')

        # If it is not already installed, install it
        # `nvm install` will implicitly use the newly-installed version
        if [[ $locally_resolved_nvm_version == "N/A" ]]; then
            nvm install "$nvm_version"
        elif [[ $(nvm current) != "$locally_resolved_nvm_version" ]]; then
            nvm use "$nvm_version"
        fi
    fi
}
alias cd='cdnvm'
cd $(pwd)
# load shopify-app-cli, but only if present and the shell is interactive
if [[ -f "$HOME/.shopify-app-cli/shopify.sh" ]] && [[ hB == *i* ]]; then
    source "$HOME/.shopify-app-cli/shopify.sh"
fi

export AWS_CREDENTIALS=~/.aws/credentials

source /Users/colin/.config/broot/launcher/bash/br
