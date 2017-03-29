#!/bin/bash
set -e

echo "=> Tagging default"

echo docker tag $IMAGE_NAME $DOCKER_REPO:latest
echo docker push $DOCKER_REPO:latest
