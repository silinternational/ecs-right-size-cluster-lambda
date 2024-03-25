#!/usr/bin/env bash

# Exit if any command below fails
set -e

# Echo each command in the script
set -x

git config --global --add safe.directory /src

# When using the provided.al2 runtime, the binary must be named "bootstrap" and be in the root directory
CGO_ENABLED=0 go build -tags lambda.norpc -ldflags="-s -w" -o bootstrap

STAGE="dev"
export ClusterNamesCSV="${ClusterNamesCSV_dev}"
if [[ "${GITHUB_REF_NAME}" == "main" ]]; then
    STAGE="prod"
    export ClusterNamesCSV="${ClusterNamesCSV_prod}"
fi

echo "Deploying ecs-right-size-cluster..."
serverless deploy --verbose --stage $STAGE
