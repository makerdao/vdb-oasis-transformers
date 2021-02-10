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

COMMIT_HASH=${TRAVIS_COMMIT::7}
IMMUTABLE_TAG=$TRAVIS_BUILD_NUMBER-$COMMIT_HASH

docker build -f dockerfiles/execute/Dockerfile . -t makerdao/vdb-oasis-execute:$TAG -t makerdao/vdb-oasis-execute:$IMMUTABLE_TAG

message LOGGING INTO DOCKERHUB
echo "$DOCKER_PASSWORD" | docker login --username "$DOCKER_USER" --password-stdin

message PUSHING EXECUTE DOCKER IMAGE
docker image push --all-tags makerdao/vdb-oasis-execute

#service deploy
if [ "$ENVIRONMENT" == "prod" ]; then
    message DEPLOYING EXECUTE TO PROD
    aws ecs update-service --cluster vdb-cluster-$ENVIRONMENT --service vdb-oasis-execute-$ENVIRONMENT --force-new-deployment --endpoint https://ecs.$PROD_REGION.amazonaws.com --region $PROD_REGION

    message DEPLOYING EXECUTE TO PRIVATE PROD
    aws ecs update-service --cluster vdb-cluster-$ENVIRONMENT --service vdb-oasis-execute-$ENVIRONMENT --force-new-deployment --endpoint https://ecs.$PRIVATE_PROD_REGION.amazonaws.com --region $PRIVATE_PROD_REGION

else
    message UNKNOWN ENVIRONMENT
    exit 1
fi

# Announce deploy
.travis/announce.sh $ENVIRONMENT vdb-oasis-execute
