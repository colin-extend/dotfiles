echo "loading aliases"

# Bash-specific
## Navigation
alias l='ls -alh'
alias ll='ls -laGh'
alias diff='diff -u'
alias back="cd -"
alias cursor="stty echo; tput cvvis;"
alias dnsflush='sudo dscacheutil -flushcache'
alias latest="ls -tr | tail -n 1"

fd() { # find directory
    local dir
    dir=$(find ${1:-.} -type d 2>/dev/null | fzf +m) && cd "$dir"
}

# cat compspec
g_proj_dir=$DEV_ROOT

dev() {
    cd $g_proj_dir/$1
}

_dev() {
    local cmd=$1 cur=$2 pre=$3
    local _cur compreply

    _cur=$g_proj_dir/$cur
    compreply=($(compgen -d "$_cur"))
    COMPREPLY=(${compreply[@]#$g_proj_dir/})
    if [[ ${#COMPREPLY[@]} -eq 1 ]]; then
        COMPREPLY[0]=${COMPREPLY[0]}/
    fi
}

# complete -F _dev -o nospace dev
# # source ./compspec
# #
# # cd /tmp/
# # mkdir -p projects/{bar,foo}{1,2}/mod{1,2}/submod{1,2}
# # touch    projects/{bar,foo}{1,2}/mod{1,2}/submod{1,2}/file{1,2}
# # dev <TAB><TAB>
# bar1 bar2 foo1 foo2
# # dev f<TAB>
# # dev foo
# # dev foo<TAB><TAB>
# foo1 foo2
# # dev foo2<TAB>
# # dev foo2/
# # dev foo2/<TAB>
# # dev foo2/mod
# # dev foo2/mod<TAB><TAB>
# foo2/mod1 foo2/mod2
# # dev foo2/mod2<TAB>
# # dev foo2/mod2/

## System
alias c='pbcopy && echo value copied to clipboard.'
alias cwd='pwd | pbcopy'
function vsort() {
    sort -bt. -k1,1 -k2,2n -k3,3n -k4,4n -k5,5n
}

## Deployments
function last_release_file() {
    echo "$DEV_ROOT/scripts/deploy/last_release"
}

function rc_prs_file() {
    echo "$DEV_ROOT/scripts/deploy/rc_prs"
}

### Increments the part of the string
## $1: version itself
## $2: number of part: 0 – major, 1 – minor, 2 – patch
increment_version() {
    local delimiter=.
    local array=($(echo "$1" | tr $delimiter '\n'))
    array[$2]=$((array[$2] + 1))
    echo $(
        local IFS=$delimiter
        echo "${array[*]}"
    )
}

alias last_release_version='cat $(last_release_file)'

function new_release_version() {
    git branch | egrep -e '(release/v[0-9].[0-9]{3}.0)$' | vsort | tail -1
}

parse_version() {
    egrep -Eo '([0-9].\d{1,3}.[0-9])'
}

function update_last_release() {
    echo $(new_release_version) >$(last_release_file)
}

function update_rc_prs() {
    echo -e "\n$(git log --pretty=format:'%h|%ad|%an|%s' $(last_release_version)..HEAD | column -t -s '|')" >$(rc_prs_file)
}

alias jirs='jira_status'
alias a2r='add_to_release'
alias lr='last_release_version'
alias cr='create_releases'
alias next_rc='git log --oneline $(last_release_version)..HEAD'
alias s2stacks='cat $DEV_ROOT/scripts/deploy/sdlc2'

# See which tickets aren't done yet
function nr() {
    grep -iv 'Done'
}

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
    DEFAULT_STACKS='extend-core,features,growth,incredibot,notifier,offers,shopify-integration,support,webhooks,contract-leads'

    if [ -z "$1" ]; then                              # Is parameter #1 zero length?
        echo "Using default environment: ${DEFAULT_ENV}" # Or no parameter passed.
        DEPLOY_ENV=${DEFAULT_ENV}
    elif [[ $1 =~ ^(dev|acceptance|stage|demo|.*sandbox)$ ]]; then
        DEPLOY_ENV=$1
    else
        echo "environment \"$1\" not recognized or allowed, exiting"
        return 1
    fi

    if [ -z "$2" ]; then                      # Is parameter #2 zero length?
        echo "Using default ref: ${DEFAULT_REF}" # Or no parameter passed.
        DEPLOY_REF=${DEFAULT_REF}
    else
        DEPLOY_REF=$2
    fi

    if [ -z "$3" ]; then                            # Is parameter #3 zero length?
        echo "Using default stacks: ${DEFAULT_STACKS}" # Or no parameter passed.
        DEPLOY_STACKS=${DEFAULT_STACKS}
    else
        DEPLOY_STACKS=$3
    fi

    echo "Running yarn install..."
    yarn install
    echo "Deploying to ${DEPLOY_ENV} with ${DEPLOY_REF}:"
    echo "Acquiring creds..."
    # not using alias to allow this to be used in all contexts
    yarn --silent --cwd "$EXTEND_CLI" run extend-cli aws creds assume -e "${DEPLOY_ENV}"
    echo "Running deploy..."
    yarn deploy --environment "${DEPLOY_ENV}" -v "${DEPLOY_REF}" --profile "${DEPLOY_ENV}" -r "${DEPLOY_STACKS}" --skip-git-check

    if [ $? -ne 0 ]; then
        echo "Error"
    fi
}

function open_tix() {
    while read -r line; do jira open "$line"; done
}

function jira_status() {
    while read -r line; do
        status=$(jira show -o status $line)
        status_count=$(echo "${status}" | wc -m)
        filtered_status=$(if [[ $status_count < 50 ]]; then echo "$status"; else echo "Error: msg length ${status_count}"; fi)
        echo "$line: $filtered_status"
    done
}

function jira_prefix() {
    cut -d '-' -f 1
}

function create_releases() {
    for line in $(jira_prefix | sort -u); do
        echo "Creating release for ${line}"
        [[ $(jira release -r -p $(echo $line | jira_prefix) -d "Autogenerated release via bash script" "$1") ]] && echo "Release $1 created for ${line}" || echo "Release not created.  Release may be empty, duplicate or invalid."
    done
}

function add_to_release() {
    INPUT_LIST=$(xargs -0)
    echo "${INPUT_LIST}" | create_releases "$1"

    if [ -z "$1" ]; then # Is parameter #1 zero length?
        echo "Error: no fix version provided."
        return 1
    else
        for line in $INPUT_LIST; do
            echo "Updating ${line} with fix version $1"
            [[ $(jira fix "$line" "$1") ]] && echo "Fix version $1 added to ${line}" || echo "Fix version could not be added to ${line}"
        done
    fi
}

## Text or String Commands
alias g='grep'
alias rz='renderizer'

function commit() {
    grep -Eoi '\b[0-9a-f]{5,40}\b' | head -1
}

function urlencode() {
    printf %s "$1" | jq -s -R -r @uri
}

alias spy='grep -B 3 -A 3 -n -C 1 -r -h --null'
alias vi='vim'
alias json='python -mjson.tool'
alias csv="sed -e 's/,,/, ,/g' | column -s, -t | less -#5 -N -S" # << cat and pipe csv to this for formatted tables
alias lt='l -t | less'
alias md=''

function jid() {
    grep -Eoi '([A-Z]{3,}-)([0-9]+)' | awk '!x[$0]++'
}

function jids() {
    LIST=$(xargs -0)
    EXCLUDE_JIDS=$(echo "$LIST" | grep 'Revert' | jid)

    if [[ $EXCLUDE_JIDS ]]; then
        echo "$LIST" | grep -v "$EXCLUDE_JIDS" | jid
    else
        echo "$LIST" | jid
    fi
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
alias jest='npx jest'
alias wdio='npx wdio wdio.conf.js'

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
alias gaa='git add --all'
alias gb='git rev-parse --abbrev-ref HEAD'
alias gc='git commit'
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
alias gd="git diff -- ':!package-lock.json' ':!yarn.lock'"
alias gref='git rev-parse --symbolic-full-name HEAD'
alias gmc='git merge --continue'
alias gpoh='git push origin HEAD'
alias grh='git reset --hard'
alias grho='fetch && git reset --hard origin/$(gb)'
alias grbc='git rebase --continue'
alias grvc='git revert --continue'
alias grp='git rev-parse'
alias git-recent='git for-each-ref --sort=-committerdate refs/heads/'
alias glo='git log --oneline'
alias glp="git log --pretty=format:'%h | %ad | %an | %s' | column -t -s ' | '"
alias glonm='git log --oneline --no-merges'
alias glob='git log --oneline $(git branch | tail -1)..HEAD'
alias gun='git reset --hard HEAD~1'      # git undo
alias glb='git branch | vsort | tail -1' # branch at last version
alias gttr='tags-reset'                  # git tags reset
alias gpdo='git push --delete origin'
alias gtr='git ls-remote --tags origin' # git tags remote
alias gpot='git push origin --tags'
alias gslnm='git shortlog --no-merges'

function gmnr() {
    git merge -Srecursive -Xno-renames $1
}

function gco-conflicts() {
    git checkout $(git status | grep 'both' | awk '{print $NF}') $1
}

function grm-del() {
    git rm $(git status | grep 'deleted by' | awk '{print $NF}') $1
}

function tags-reset() {
    # reset local tags with remote ones
    git tag -l | xargs git tag -d && git fetch -t
}

# Javascript
alias node="env NODE_NO_READLINE=1 rlwrap node"
alias ni='node inspect'
alias nd='node debug'
alias yyt='yarn && yarn typecheck && yarn lint --quiet'

# Local
function ec() {
    yarn --silent --cwd "/Users/colin/.extend-cli" run extend-cli $1 $2 $3 $4 $5 $6 $7
}

# App-specific
alias mi='micro'
alias ssubl='for f in /Users/colin/Library/Application\ Support/Sublime\ Text\ 3/Local/*session; do mv "$f" "$(echo "$f".previous)"; done && subl'

## Debugging
alias reset_audio="sudo killall -9 AudioComponentRegistrar && sudo killall -9 coreaudiod"

## Special
alias spoof='spoof-mac randomize --wifi' # https://github.com/feross/SpoofMAC
function weather() {
    if [ -z "$1" ]; then
        curl "wttr.in"
    else
        curl "wttr.in/$(urlencode "$1")?format=4"
    fi
}
