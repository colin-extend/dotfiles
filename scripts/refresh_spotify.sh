#!/bin/bash
printf "Starting spotify library refresh at $(date)\n\n"
osascript -e 'tell application id "com.runningwithcrayons.Alfred" to run trigger "refresh_library" in workflow "com.vdesabou.spotify.mini.player" with argument "cron job activation"'
