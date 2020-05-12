# Bash-specific
## Navigation
alias l='ls -alh'
alias ll='ls -laGh'
alias diff='diff -u'
alias back="cd -"
alias cursor="stty echo; tput cvvis;"
alias dnsflush='sudo dscacheutil -flushcache'
alias latest="ls -tr | tail -n 1"

## System functions
alias cwd='pwd | pbcopy'

## Text or String Commands
alias spy='grep -B 3 -A 3 -n -C 1 -r -h --null'
alias vi='vim'
alias json='python -mjson.tool'
alias csv="sed -e 's/,,/, ,/g' | column -s, -t | less -#5 -N -S"  # << cat and pipe csv to this for formatted tables
alias lt='l -t | less'
alias md=''
alias jira_tix="grep -Eo '([A-Z]{3,}-)([0-9]+)' | uniq | awk '{print "https://helloextend.atlassian.net/browse/" $0}'" # << pipe to this for jira tix


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
alias commit="git show | grep 'commit' | awk '{print $2}'"

# Javascript
alias node="env NODE_NO_READLINE=1 rlwrap node"
alias ni='node inspect'
alias nd='node debug'

## Special
alias spoof='spoof-mac randomize --wifi'  # https://github.com/feross/SpoofMAC

## Functions
function git-jira-ids() {
  git log $1 | grep -Eo '([A-Z]{3,}-)([0-9]+)' | uniq
}
