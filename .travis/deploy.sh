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
TAG="latest"

if [ "$ENVIRONMENT" == "prod" ]; then
  REGION=$PROD_REGION
elif [ "$ENVIRONMENT" == "private-prod" ]; then
  REGION=$PRIVATE_PROD_REGION
  ENVIRONMENT="prod"
elif [ "$ENVIRONMENT" == "qa" ]; then
  REGION=$QA_REGION
  TAG="develop"
else
    message UNKNOWN ENVIRONMENT
    echo 'You must specify an environment (bash deploy.sh <ENVIRONMENT>).'
    echo 'Allowed values are ("prod", "qa")'
    exit 1
fi

message BUILDING EXECUTE DOCKER IMAGE

COMMIT_HASH=${TRAVIS_COMMIT::7}
IMMUTABLE_TAG=$TRAVIS_BUILD_NUMBER-$COMMIT_HASH

docker build -f dockerfiles/execute/Dockerfile . -t makerdao/vdb-oasis-execute:$TAG -t makerdao/vdb-oasis-execute:$IMMUTABLE_TAG

message LOGGING INTO DOCKERHUB
echo "$DOCKER_PASSWORD" | docker login --username "$DOCKER_USER" --password-stdin

message PUSHING EXECUTE DOCKER IMAGE
docker push makerdao/vdb-oasis-execute:$TAG
docker push makerdao/vdb-oasis-execute:$IMMUTABLE_TAG

message DEPLOYING OASIS EXECUTE TO ${ENVIRONMENT} in ${REGION}
    aws ecs update-service --cluster vdb-cluster-$ENVIRONMENT --service vdb-oasis-execute-$ENVIRONMENT --force-new-deployment --endpoint https://ecs.$REGION.amazonaws.com --region $REGION

# Announce deploy
.travis/announce.sh $ENVIRONMENT vdb-oasis-execute
