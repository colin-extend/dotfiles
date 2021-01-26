#!/bin/bash
printf "Beginning semi-hourly creds refresh at $(date)\n\n"
cd "/Users/colin/dev/node-core"
cred-helper assume -e stage || echo 'Failed to get stage creds'
cred-helper assume -e acceptance || echo 'Failed to get acceptance creds'
cred-helper assume -e demo || echo 'Failed to get demo creds'
