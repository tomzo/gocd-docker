#!/bin/bash

if [ "$(ls -A installers)" ]; then
    echo "Using packages from installers/ to build image"
else
    echo "installers/ directory is empty. build packages first"
    exit 1
fi

AGENT_IMAGE_NAME=gocd-agent

if [ -n "$DOCKER_REGISTRY" ];then
  AGENT_IMAGE_NAME="$DOCKER_REGISTRY/$AGENT_IMAGE_NAME"
fi

if [ -n "$TAG" ];then
  AGENT_IMAGE_NAME="$AGENT_IMAGE_NAME:$TAG"
fi

echo "Building Go agent image - $AGENT_IMAGE_NAME"
docker build -f Dockerfile.gocd-agent -t $AGENT_IMAGE_NAME .

echo "Building Go agent image finished. You can push with"
echo "docker push $AGENT_IMAGE_NAME"
