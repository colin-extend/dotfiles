#!/bin/bash
shopt -s expand_aliases
source ~/.bash_aliases
printf "Beginning merge of develop to partnerssandbox on client at $(date)\n\n"

cd "/Users/colin/dev/client"
branch=$(git rev-parse --abbrev-ref HEAD)
fetch

[ $(git diff origin/partnerssandbox..origin/develop | wc -m) == 0 ] && echo 'Branches up to date.  Exiting.' && exit 1

git checkout develop
git reset --hard origin/develop
git checkout partnerssandbox
git reset --hard origin/partnerssandbox
git merge --no-edit origin/develop || (echo 'Error performing merge.' && exit 1)
git push origin partnerssandbox || (echo 'Error performing push.' && exit 1)
git checkout $branch
