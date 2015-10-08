#!/bin/bash

set -e

REPO=${REPO:-https://github.com/gocd/gocd.git}
BRANCH=${BRANCH:-master}

cd /home/gocd
if [ -z "$COMMIT" ]; then
  echo "Building Go from ${REPO} branch ${BRANCH}"
  git fetch "${REPO}" "${BRANCH}"
  git reset --hard FETCH_HEAD
else
  echo "Building Go from ${REPO} commit ${COMMIT}"
  git remote add build "${REPO}"
  git fetch build
  git checkout "$COMMIT"
done

./bn clean cruise:prepare
