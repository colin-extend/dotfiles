# Bash-specific

## Navigation
alias l='ls -alh'
alias ll='ls -laGh'
alias diff='diff -u'
alias back="cd -"
alias cursor="stty echo"
alias dnsflush='sudo dscacheutil -flushcache'
alias latest="ls -tr | tail -n 1"

## Bash functions

alias cwd='pwd | pbcopy'

## Text or String Commands
alias spy='grep -B 3 -A 3 -n -C 1 -r -h --null'
alias vi='vim'
alias json='python -mjson.tool'
alias csv="sed -e 's/,,/, ,/g' | column -s, -t | less -#5 -N -S"  # << cat and pipe csv to this for formatted tables
alias lt='l -t | less'

# Testing

alias cas='casperjs test --ignore-ssl-errors=yes'
alias rs='rspec --format documentation --color'

# Web apps

# Marqeta Apps

## Vagrant

alias vu='vagrant up'
alias vh='vagrant halt'
alias vgs='vagrant global-status'
alias sshv='vagrant ssh'


## Git

alias commits='git log --graph --all --oneline --decorate'
