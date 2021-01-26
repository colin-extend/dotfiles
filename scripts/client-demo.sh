#!/bin/bash
shopt -s expand_aliases
source ~/.bash_aliases
printf "Beginning merge of master to demo on client at $(date)\n\n"

cd "/Users/colin/dev/client"
branch=$(git rev-parse --abbrev-ref HEAD)
fetch
[ $(git diff origin/demo..origin/master | wc -m) == 0 ] && echo 'Branches up to date.  Exiting.' && exit 1

git checkout master
git reset --hard origin/master
git checkout demo
git reset --hard origin/demo
git merge --no-edit origin/master || (echo 'Error performing merge.' && exit 1)
git push origin demo || (echo 'Error performing push.' && exit 1)
git checkout $branch
