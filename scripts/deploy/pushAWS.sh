#!/bin/bash

# pushes commit to env or uses defaults
bold=$(tput bold)
normal=$(tput sgr0)

DEPLOY_ENV=
DEPLOY_REF=
DEPLOY_STACKS=
DEFAULT_ENV='acceptance'
DEFAULT_REF='refs/heads/master'
DEFAULT_STACKS='extend-core,features,growth,incredibot,notifier,offers,shopify-integration,support,webhooks,contract-leads'

OPTIND=1 # Reset in case getopts has been used previously in the shell.

while getopts "e:r:s:" option; do
    case "$option" in
    e)
        DEPLOY_ENV=${OPTARG}
        if [[ ! $DEPLOY_ENV =~ ^(dev|acceptance|stage|demo|.*sandbox)$ ]]; then
            echo "environment \"$OPTARG\" not recognized or allowed, exiting"
            exit 1
        elif [ -z "${OPTARG}" ]; then
            echo "Using default environment, ${DEFAULT_ENV}"
        fi
        ;;
    r)
        DEPLOY_REF=${OPTARG}
        if [ -z "${OPTARG}" ]; then
            echo "Using default ref: ${DEFAULT_REF}" # Or no parameter passed.
        fi
        ;;
    s)
        DEPLOY_STACKS=${OPTARG}
        if [ -z "${OPTARG}" ]; then
            echo "Using default stacks: ${DEFAULT_STACKS}" # Or no parameter passed.
        fi
        ;;
    ?)
        echo "Invalid option: -$option exiting" >&2
        exit 1
        ;;
    esac
done

shift $((OPTIND - 1))

[ "${1:-}" = "--" ] && shift

echo "Running yarn install..."
yarn install
echo "Deploying to ${bold}${DEPLOY_ENV:=$DEFAULT_ENV}${normal} with stacks ${bold}${DEPLOY_STACKS:=$DEFAULT_STACKS}${normal} at ref ${bold}${DEPLOY_REF:=$DEFAULT_REF}${normal}"
echo "Acquiring creds..."
# not using alias to allow this to be used in all contexts
yarn --silent --cwd "$EXTEND_CLI" run extend-cli aws creds assume -e "${DEPLOY_ENV}"
echo "Running deploy..."
yarn deploy --environment "${DEPLOY_ENV:=$DEFAULT_ENV}" -v "${DEPLOY_REF:=$DEFAULT_REF}" --profile "${DEPLOY_ENV-$DEPLOY_ENV}" -r "${DEPLOY_STACKS:=$DEFAULT_STACKS}" --skip-git-check

if [ $? -ne 0 ]; then
    echo "An error occurred"
fi
