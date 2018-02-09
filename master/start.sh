#!/bin/bash
docker stop master
docker rm master
docker volume rm common-log
docker volume create common-log
docker build -t master --no-cache=true master
docker run -d --rm --name master \
  --mount source=common-log,target=/var/log/common-log master
logging/start.sh
static/start.sh