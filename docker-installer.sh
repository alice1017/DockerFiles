#!/bin/sh
# coding: utf-8

# docker-installer.sh
# Copyright (c) 2016 Hayato Tominaga
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# Download installer
wget --no-check-certificate "https://raw.githubusercontent.com/alice1017/DockerFiles/master/docker-installer.sh"
chmod +x ./docker-installer.sh

# Install docker
sudo apt-get update
sudo apt-get install -y docker.io

sleep 5

# Install docker-machine
sudo wget --no-check-certificate -O /usr/bin/docker-machine "https://github.com/docker/machine/releases/download/v0.1.0/docker-machine_darwin-amd64"
sudo chmod +x /usr/bin/docker-machine
