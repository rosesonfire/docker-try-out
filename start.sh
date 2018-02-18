#!/bin/bash

# Build the registry node image

docker build -t node_registry nodes/registry - ok

# Run the registry node

docker run -d -p 5000:5000 --restart always --name node_registry node_registry - ok

# Build the service images

docker build -t localhost:5000/service/logging services/logging - ok
docker build -t localhost:5000/service/static services/static - ok

# Push the service images to the registry node

docker push localhost:5000/service/logging - ok
docker push localhost:5000/service/static - ok

# Remove the service images

docker rmi localhost:5000/service/logging - ok
docker rmi localhost:5000/service/static - ok

# Create docker swarm

docker run --rm swarm create - ok - copy the id

# Build the slave node images

docker build -t node_machine1 nodes/machine1 - ok
docker build -t node_machine2 nodes/machine2 - ok
docker build -t node_machine3 nodes/machine3 - ok

# Run the slave nodes

docker run --rm -d --name node_machine1 node_machine1 join --addr=192.168.0.1:2375 token://535bc8817b52620e55c7f68e988e7ffb9386b2d46239935407454767bb2c1996
docker run --rm -d --name node_machine2 node_machine2 join --addr=192.168.0.2:2375 token://535bc8817b52620e55c7f68e988e7ffb9386b2d46239935407454767bb2c1996
docker run --rm -d --name node_machine3 node_machine3 join --addr=192.168.0.3:2375 token://535bc8817b52620e55c7f68e988e7ffb9386b2d46239935407454767bb2c1996

# Build the master node image

docker build -t node_master nodes/master - ok

# Run the master node

docker run --rm -d -p 2375:2375 --name node_master node_master manage token://535bc8817b52620e55c7f68e988e7ffb9386b2d46239935407454767bb2c1996 - ok

# Pull the service images into the master node

docker -H localhost:2375 pull localhost:5000/service/logging


# Set up the services
