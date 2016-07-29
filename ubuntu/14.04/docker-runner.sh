#!/bin/sh
# coding: utf-8

# download dockerfile
wget --no-check-certificate "https://raw.githubusercontent.com/alice1017/DockerFiles/master/ubuntu/14.04/Dockerfile"

# build image
docker build -t ubuntu-sshd .

if [ $? != 0 ]; then
  echo "Docker build failed.\n"
  exit 1
fi

# docker run sshd
docker run -h ubuntu-sshd -d -p 2222:22 ubuntu-sshd
