#!/usr/bin/env bash

setUpDockerComposeDotEnv() {
  [ -e .env ] && rm .env
  echo "HOST_UID=`id -u`" >> .env
  echo "ROOT_DIR"=${ROOT_DIR} >> .env
}

if ! command -v greadlink > /dev/null; then
  ROOT_DIR=`readlink -f ${PWD}`
else
  ROOT_DIR=`greadlink -f ${PWD}`
fi
cd .Build
setUpDockerComposeDotEnv
docker-compose run testing
SUITE_EXIT_CODE=$?
docker-compose down
exit $SUITE_EXIT_CODE