#!/bin/bash
source ~/.bash_profile

curl -vvv "https://circleci.com/api/v1.1/project/github/helloextend/backend-e2e/tree/circleci-project-setup" \
    -u ${CIRCLE_API_USER_TOKEN}: \
    -d "build_parameters[CIRCLE_JOB]=build"
