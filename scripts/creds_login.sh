#!/bin/bash
shopt -s expand_aliases
source /Users/colin/.bash_profile

printf "Starting ec creds login at $(date)\n\n"
ec aws creds login
ec yarn login
