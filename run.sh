#!/bin/bash
mkdir .Build
cd .Build
wget https://raw.githubusercontent.com/dpool/test-base/main/docker-compose.yml
wget https://raw.githubusercontent.com/dpool/test-base/main/runTests.sh
cd ../