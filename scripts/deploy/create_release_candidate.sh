#!/bin/bash -x
shopt -s expand_aliases
source ~/.bash_aliases

# SLACK_URL="https://hooks.slack.com/workflows/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" # deployments
SLACK_URL="https://hooks.slack.com/workflows/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" #. slack_sandbox
# SLACK_URL="https://webhook.site/56a992e2-41bb-423d-994e-b876b4801114" # webhook tester

# check out master in node-core
cd "$DEV_ROOT/node-core"
git fetch --all
git clean -fd
git checkout master
grho

# create

update_rc_prs
all_rc_prs=$(cat $(rc_prs_file))
rc_status_list=$(echo "$all_rc_prs" | jids | jirs)
all_not_ready=$(echo "$rc_status_list" | nr)
carryover_prs=$(cat $(carryover_prs_file) | tr -d "'\"\`" || echo "n/a")
all_sdlc2=$(echo "$rc_status_list" | egrep 'PLAN|AUTH|WARM')

new_rc_version_number() {
	increment_version $(last_release_version | parse_version | sed "s/.$/0/") $1
}

new_rc_version=$(new_rc_version_number 1)
initial_rc_branch_name=$(echo "release/v$new_rc_version-rc0")
rc_resolution_branch=$(echo "release/v$new_rc_version-rc1")

curl --trace-ascii /tmp/great.log --location $SLACK_URL --header 'Content-Type: application/json' --data-raw "{ \
\"initial_rc_branch_name\": \"${initial_rc_branch_name}\", \
\"all_rc_prs\": \"$(echo "$all_rc_prs" | tr -d "'\"\`")\",\
\"rc_version\": \"$(echo "v$new_rc_version")\",\
\"unresolved_eng_svcs_tickets\": \"$(echo "$all_not_ready" | egrep 'ENG' || echo 'n/a')\",\
\"unresolved_cust_tickets\": \"$(echo "$all_not_ready" | egrep 'CUST' || echo 'n/a')\",\
\"unresolved_claims_tickets\": \"$(echo "$all_not_ready" | egrep 'CLAIM|HOOKS' || echo 'n/a')\",\
\"unresolved_merch_tickets\": \"$(echo "$all_not_ready" | egrep 'MERCH' || echo 'n/a')\",\
\"unresolved_partner_tickets\": \"$(echo "$all_not_ready" | egrep 'PAR' || echo 'n/a')\",\
\"all_sdlc2\": \"$(echo "$all_sdlc2")\", \
\"rc_resolution_branch\": \"$(echo "$rc_resolution_branch")\",\
\"carryover_prs\": \"$(echo "$carryover_prs" | tr -d "'\"\`")\"\
}"

# working:

# curl --trace-ascii /tmp/great.log --location $SLACK_URL --header 'Content-Type: application/json' --data-raw "{ \
# \"initial_rc_branch_name\": \"${initial_rc_branch_name}\", \
# \"all_rc_prs\": \"$(echo "$all_rc_prs" | tr -d '"')\",\
# \"rc_version\": \"$(echo "v$new_rc_version")\",\
# \"unresolved_eng_svcs_tickets\": \"$(echo "$all_not_ready" | egrep 'ENG' || echo 'n/a')\",\
# \"unresolved_cust_tickets\": \"$(echo "$all_not_ready" | egrep 'CUST' || echo 'n/a')\",\
# \"unresolved_claims_tickets\": \"$(echo "$all_not_ready" | egrep 'CLAIM|HOOKS' || echo 'n/a')\",\
# \"unresolved_merch_tickets\": \"$(echo "$all_not_ready" | egrep 'MERCH' || echo 'n/a')\",\
# \"unresolved_partner_tickets\": \"$(echo "$all_not_ready" | egrep 'PAR' || echo 'n/a')\",\
# \"all_sdlc2\": \"$(echo "$all_sdlc2")\", \
# \"rc_resolution_branch\": \"$(echo "$rc_resolution_branch")\",\
# \"carryover_prs\": \"$(echo "$carryover_prs" | tr -d '"')\"\
# }"
