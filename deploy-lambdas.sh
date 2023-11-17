#!/usr/bin/env bash

# Exit if any command below fails
set -e

# Echo each command in the script
set -x

# build binary
CGO_ENABLED=0 go build -tags lambda.norpc -ldflags="-s -w" -o bootstrap

STAGE="dev"
export ClusterNamesCSV="${ClusterNamesCSV_dev}"
if [[ "${CI_BRANCH}" == "main" ]]; then
    STAGE="prod"
    export ClusterNamesCSV="${ClusterNamesCSV_prod}"
fi

echo "Deploying ecs-right-size-cluster..."
serverless deploy --verbose --stage $STAGE
