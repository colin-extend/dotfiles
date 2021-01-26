#!/bin/bash

shopt -s expand_aliases
source ~/.bash_aliases

cd "$DEV_ROOT/node-core"

lastPRs=$(glop $(last_release_version)..$(new_release_version))
prStatuses=$(echo "$lastPRs" | jids | jirs)

printf "Most recent set of PRs:\n-----------------------------------\n"
echo "$lastPRs"

printf "Most recent set of PRs with Statuses:\n-----------------------------------\n"
echo "$prStatuses"

echo "$lastPRs" >$(rc_prs_file)

echo "Updating carroyver PRs..."
create_carryover_prs

echo "Updating last release version to $(new_release_version)"
update_last_release
