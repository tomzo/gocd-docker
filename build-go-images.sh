#!/bin/bash

PACKAGES=${PACKAGES:-deb win}
REPO=${REPO:-https://github.com/gocd/gocd.git}
BRANCH=${BRANCH:-master}

set -e

if [ -z "$COMMIT" ]; then
  echo "Building Go from ${REPO} branch ${BRANCH}"
  TAG=${BRANCH}
else
  echo "Building Go from ${REPO} commit ${COMMIT}"
  TAG=${COMMIT}
fi

echo "Building development environment"
docker build -f Dockerfile.gocd-build-installer -t gocd-build-installer .

echo "Building Go packages"
docker run -it --rm=true -v `pwd`/packages:/installers -e REPO=$REPO -e BRANCH=$BRANCH -e COMMIT=$COMMIT gocd-build-installer $PACKAGES

echo "Building Go server image"
docker build -f Dockerfile.gocd-server -t gocd-server:$TAG .

echo "Building Go agent image"
docker build -f Dockerfile.gocd-agent -t gocd-agent:$TAG .
