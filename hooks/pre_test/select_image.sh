#!/bin/bash
set -e

echo "=> Select image to test"
sed -e "1s/FROM.+/FROM $IMAGE_NAME\n/" tests/Dockerfile
