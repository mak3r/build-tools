#!/bin/bash  



# install build x
curl -sfL test.docker.com | sh -
####
# ~/.docker/config.json:
####
# {
#    "experimental": "enabled"
# }
####
cat ~/.docker/config.json 
sudo apt-get remove --purge docker-ce

# install qemu-user before creating the builder
sudo apt-get install qemu-user-static

# create a builder for the raspberry pi series boards
docker buildx create --name rpi3plus --platform linux/arm64,linux/arm/v7
docker buildx use rpi3plus
docker buildx inspect --bootstrap
docker buildx inspect rpi3plus

# build the image
docker buildx build --platform linux/arm,linux/arm64 -t mak3r/rpi-audio-out:latest .

# load the image into the local repository
docker buildx build --platform linux/arm64 -t mak3r/rpi-audio-out:latest --load .
docker buildx build --platform linux/arm/v7 -t mak3r/rpi-audio-out:latest --load .

# push the image to docker hub
docker buildx build --platform linux/arm64 -t mak3r/rpi-audio-out:latest --push .
docker buildx build --platform linux/arm/v7 -t mak3r/rpi-audio-out:latest --push .

# cleanup
#docker buildx rm rpi3plus

# KNOWN ISSUES
# sometimes the builder needs to be deleted and rebuilt
#
#ERROR# failed to solve: rpc error: code = Unknown desc = failed to solve with frontend dockerfile.v0: failed to load LLB: runtime execution on platform linux/arm64 not supported
# 
#SOLUTION# 
# be sure qemu-user-static is installed
# delete the builder
# recreate the builder
