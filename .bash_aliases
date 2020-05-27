# Bash-specific
## Navigation
alias l='ls -alh'
alias ll='ls -laGh'
alias diff='diff -u'
alias back="cd -"
alias cursor="stty echo; tput cvvis;"
alias dnsflush='sudo dscacheutil -flushcache'
alias latest="ls -tr | tail -n 1"

## System
alias cwd='pwd | pbcopy'

## Functions
# Append extend JIRA URL
function append_jira_url() {
    awk '!x[$0]++ {print "https://helloextend.atlassian.net/browse/" $0}'
}

# parses JIRA ticket url from a list of commits
function tix() {
    jids | append_jira_url
}

# prints 2nd column
function get_column_two() { awk '{print $2}'; }

# pushes commit to env or uses defaults
function push() {
    DEFAULT_ENV='acceptance'
    DEFAULT_REF='refs/heads/master'

    if [ -z "$1" ]; then                                 # Is parameter #1 zero length?
        echo "Using default environment: ${DEFAULT_ENV}" # Or no parameter passed.
        DEPLOY_ENV=${DEFAULT_ENV}
    elif [[ $1 =~ ^(dev|acceptance|stage|demo)$ ]]; then
        DEPLOY_ENV=$1
    else
        echo "environment \"$1\" not recognized or allowed, exiting"
        return 1
    fi

    if [ -z "$2" ]; then                         # Is parameter #1 zero length?
        echo "Using default ref: ${DEFAULT_REF}" # Or no parameter passed.
        DEPLOY_REF=${DEFAULT_REF}
    else
        DEPLOY_REF=$2
    fi

    echo "Deploying to ${DEPLOY_ENV} with ${DEPLOY_REF}:"
    echo "Acquiring creds..."
    cred-helper assume -e "${DEPLOY_ENV}"
    echo "Running deploy..."
    yarn run deploy --environment "${DEPLOY_ENV}" -v "${DEPLOY_REF}" --profile "${DEPLOY_ENV}" --skip-git-check
}

function open_tix() {
    while read -r line; do jira open "$line"; done
}

## Text or String Commands
alias spy='grep -B 3 -A 3 -n -C 1 -r -h --null'
alias vi='vim'
alias json='python -mjson.tool'
alias csv="sed -e 's/,,/, ,/g' | column -s, -t | less -#5 -N -S" # << cat and pipe csv to this for formatted tables
alias lt='l -t | less'
alias md=''
alias jids="grep -Eoi '([A-Z]{3,}-)([0-9]+)' | uniq" # << pipe to this for jira tix

# Testing

alias cas='casperjs test --ignore-ssl-errors=yes'
alias rs='bundle exec rspec --format documentation --color'
alias ms='DOMAIN=master bundle exec rspec --format documentation --color'
alias bs='RAILS_ENV=test bundle exec spec --color --format nested'
alias nw='nightwatch'

# Web apps

alias brake='bundle exec rake'
alias thin='bundle exec thin start'
alias rc='bundle exec script/console'
alias lerna='npx lerna'

# Vagrant

alias vu='vagrant up'
alias vh='vagrant halt'
alias vgs='vagrant global-status'
alias sshv='vagrant ssh'

# Python
alias python='python3'
alias pip='pip3'

# Git
alias commits='git log --graph --all --oneline --decorate'
alias branches='git for-each-ref --sort=-committerdate refs/heads/'
alias fetch='git fetch --all -p' # prunes dead remote branches
alias gco='git checkout'
alias gcob='git checkout -b'
alias gcom='git checkout master'
alias gbu='git branch -u'
alias gs='git status'
alias gcl='git clone'
alias gall='git add -A'
alias gdel='git branch -D'
alias gcp='git cherry-pick'
alias grh='git reset --hard'
alias git-recent='git for-each-ref --sort=-committerdate refs/heads/'
alias glo='git log --oneline'
alias commit="git rev-parse HEAD"
alias gco-conflicts="git checkout $(git status | grep 'both' | awk '{print $NF}')"

# Javascript
alias node="env NODE_NO_READLINE=1 rlwrap node"
alias ni='node inspect'
alias nd='node debug'

## Special
alias spoof='spoof-mac randomize --wifi' # https://github.com/feross/SpoofMAC
