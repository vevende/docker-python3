#!/bin/bash
set -e

echo "=> Select image to test"
echo cp -ar ../docker-compose.test.yml .
echo cp -ar ../tests .
echo sed -e "1s/FROM.+/FROM $IMAGE_NAME\n/" tests/Dockerfile
