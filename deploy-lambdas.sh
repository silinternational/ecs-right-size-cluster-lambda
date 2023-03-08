#!/usr/bin/env bash

# Exit if any command below fails
set -e

# Echo each command in the script
set -x

# build binary
go build -ldflags="-s -w" -o ecs-right-size-cluster

STAGE="dev"
if [[ "${CI_BRANCH}" == "master" ]]; then
    STAGE="prod"
fi

echo "Deploying ecs-right-size-cluster..."
serverless deploy --verbose --stage $STAGE
