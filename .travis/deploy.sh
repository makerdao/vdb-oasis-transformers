#! /usr/bin/env bash

set -e

function message() {
    echo
    echo -----------------------------------
    echo "$@"
    echo -----------------------------------
    echo
}

ENVIRONMENT=$1
if [ "$ENVIRONMENT" == "prod" ]; then
    TAG=latest
else
    message UNKNOWN ENVIRONMENT
    echo 'You must specify an environment (bash deploy.sh <ENVIRONMENT>).'
    echo 'Allowed values are ("prod")'
    exit 1
fi

message BUILDING EXECUTE DOCKER IMAGE
docker build -f dockerfiles/execute/Dockerfile . -t makerdao/vdb-oasis-execute:$TAG

message LOGGING INTO DOCKERHUB
echo "$DOCKER_PASSWORD" | docker login --username "$DOCKER_USER" --password-stdin

message PUSHING EXECUTE DOCKER IMAGE
docker push makerdao/vdb-oasis-execute:$TAG

#service deploy
if [ "$ENVIRONMENT" == "prod" ]; then
    message DEPLOYING EXECUTE
    aws ecs update-service --cluster vdb-cluster-$ENVIRONMENT --service vdb-oasis-execute-$ENVIRONMENT --force-new-deployment --endpoint https://ecs.$PROD_REGION.amazonaws.com --region $PROD_REGION
else
    message UNKNOWN ENVIRONMENT
    exit 1
fi

# Announce deploy
.travis/announce.sh $ENVIRONMENT vdb-oasis-execute
