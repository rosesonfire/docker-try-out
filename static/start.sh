#!/bin/bash
docker stop static
docker rm static
docker build -t static --no-cache=true static
docker run -d --rm --name static -p 8080:80 \
  --mount source=common-log,target=/var/log/common-log static