#!/bin/bash
docker stop logging
docker rm logging
docker build -t logging --no-cache=true logging
docker run -d --rm --name logging -p 8081:8081 \
  --mount source=common-log,target=/var/log/common-log logging