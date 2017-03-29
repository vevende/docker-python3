#!/bin/bash
set -e

echo "=> Tagging default"

if [ "$DOCKER_TAG" = 'jessie' ]; then
    docker tag $IMAGE_NAME $DOCKER_REPO:latest
    docker push $DOCKER_REPO:latest
fi
