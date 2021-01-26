#!/bin/bash
shopt -s expand_aliases
source ~/.bash_aliases
source ~/.bash_var_exports

echo "Dev root is $DEV_ROOT"

printf "Beginning default acceptance push at $(date)\n\n"
cd "/Users/colin/dev/node-core"
branch=$(git rev-parse --abbrev-ref HEAD)
fetch
git checkout master
git pull
pushAWS
printf "\n\n................acceptance build triggered....................\n\n"
# 0 10,16 * * 1,2,3,4,5
git checkout $branch
