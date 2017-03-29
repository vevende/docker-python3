#!/bin/bash
set -e

echo "=> Select image to test"
cp -ar ../tests $DOCKER_TAG/
sed -e "1s/FROM.+/FROM $IMAGE_NAME\n/" tests/Dockerfile
