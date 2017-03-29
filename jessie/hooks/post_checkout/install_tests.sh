#!/bin/bash
set -e

echo "=> Select image to test"
cp -ar ../docker-compose.test.yml .
cp -ar ../tests .
sed -e "1s/FROM.+/FROM $IMAGE_NAME\n/" tests/Dockerfile
