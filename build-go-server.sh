#!/bin/bash

if [ "$(ls -A installers)" ]; then
    echo "Using packages from installers/ to build image"
else
    echo "installers/ directory is empty. build packages first"
    exit 1
fi

SERVER_IMAGE_NAME=gocd-server

if [ -n "$DOCKER_REGISTRY" ];then
  SERVER_IMAGE_NAME="$DOCKER_REGISTRY/$SERVER_IMAGE_NAME"
fi

if [ -n "$TAG" ];then
  SERVER_IMAGE_NAME="$SERVER_IMAGE_NAME:$TAG"
fi

echo "Building Go server image - $SERVER_IMAGE_NAME"
docker build -f Dockerfile.gocd-server -t $SERVER_IMAGE_NAME .

echo "Building Go server image finished. You can push with"
echo "docker push $SERVER_IMAGE_NAME"
