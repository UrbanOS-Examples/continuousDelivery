#!/bin/bash

#docker build --name nexus jefflutz/nexus-aws .
docker build --no-cache . -t jefflutz/nexus-aws-ad
