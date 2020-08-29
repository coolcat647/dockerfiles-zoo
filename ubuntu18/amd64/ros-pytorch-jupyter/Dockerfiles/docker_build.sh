#!/usr/bin/env sh
COLOR_RED='\033[0;31m'
COLOR_YELLOW='\033[0;33m'
COLOR_NC='\033[0m'

docker build -t coolcat647/ubuntu18-ros-pytorch:cuda10.0 --build-arg user_id=$(id -u) -f Dockerfile-cuda10 .