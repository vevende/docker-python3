#!/bin/bash
set -e

echo "=> Tagging default"

docker tag $IMAGE_NAME $DOCKER_REPO:latest
docker push $DOCKER_REPO:latest
