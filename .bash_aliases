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
alias c='pbcopy && echo value copied to clipboard.'
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
function pushAWS() {
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

    echo "Running yarn install..."
    yarn install
    echo "Deploying to ${DEPLOY_ENV} with ${DEPLOY_REF}:"
    echo "Acquiring creds..."
    cred-helper assume -e "${DEPLOY_ENV}"
    echo "Running deploy..."
    yarn run deploy --environment "${DEPLOY_ENV}" -v "${DEPLOY_REF}" --profile "${DEPLOY_ENV}" --skip-git-check

    if [ $? -ne 0 ]; then
        echo "Error"
    fi
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

function jids() {
    # << pipe to this for jira tix.  grep case insensitive jira tix, then use awk to remove dupes
    grep -Eoi '([A-Z]{3,}-)([0-9]+)' | awk '!x[$0]++'
}

function trunc() {
    # truncates last number of lines passed to it (e.g.  glo release/v1.62.0..HEAD | trunc 9)
    tail -r | tail -n "+$1" | tail -r
}

function trim() {
    # removes last line of a file
    # follow this with a filename (e.g. trim log.txt)
    sed -i '' -e '$ d'
}

function gread() {
    G=$2
    S=$3
    if [ -z $G ]; then G=""; fi
    if [ -z $S ]; then S="Moira"; fi
    # Live tail and read specific lines, or leave blank for all lines
    tail -f -n 0 $1 | grep -i --line-buffered "$G" | while read line; do echo $line | say -v $S; done
}

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
alias commit="git rev-parse g"
alias gb='git rev-parse --abbrev-ref HEAD'
alias gco='git checkout'
alias gcob='git checkout -b'
alias gcom='git checkout master'
alias gbu='git branch -u'
alias gs='git status'
alias gcl='git clone'
alias gall='git add -A'
alias gdel='git branch -D'
alias gcp='git cherry-pick'
alias gcpc='git cherry-pick --continue'
alias gref='git rev-parse --symbolic-full-name HEAD'
alias gmc='git merge --continue'
alias gpoh='git push origin HEAD'
alias grh='git reset --hard'
alias grbc='git rebase --continue'
alias grvc='git revert --continue'
alias git-recent='git for-each-ref --sort=-committerdate refs/heads/'
alias glo='git log --oneline'
alias commit="git rev-parse HEAD"
alias glob='git log --oneline $(git branch | tail -1)..HEAD'

function gmnr() {
    git merge -Srecursive -Xno-renames $1
}

function gco-conflicts() {
    git checkout $(git status | grep 'both' | awk '{print $NF}') $1
}

# Javascript
alias node="env NODE_NO_READLINE=1 rlwrap node"
alias ni='node inspect'
alias nd='node debug'
alias yyt='yarn && yarn typecheck'

# App-specific
alias ssubl='for f in /Users/colin/Library/Application\ Support/Sublime\ Text\ 3/Local/*session; do mv "$f" "$(echo "$f".previous)"; done && subl'

## Special
alias spoof='spoof-mac randomize --wifi' # https://github.com/feross/SpoofMAC
