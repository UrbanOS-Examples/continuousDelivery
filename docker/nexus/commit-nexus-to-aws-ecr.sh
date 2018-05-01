#!/bin/bash

## Reference:  https://us-east-2.console.aws.amazon.com/ecs/home?region=us-east-2#/repositories/create/new

# First, show running local docker container with Nexus changes to support AD
docker ps

# Second, take the container ID from the running container and run docker commit
docker commit 8c6c1ba7b068 647770347641.dkr.ecr.us-east-2.amazonaws.com/nexus-aws-ad:latest

# Last, push saved local image to AWS ECR
docker push 647770347641.dkr.ecr.us-east-2.amazonaws.com/nexus-aws-ad:latest
