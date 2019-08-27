#!/usr/bin/env sh
COLOR_RED='\033[0;31m'
COLOR_YELLOW='\033[0;33m'
COLOR_NC='\033[0m'

if [ $# -gt 0 ]; then
    if [ "$1" == "cuda9" ]; then
        docker build -t coolcat647/ros-pytorch:cuda9.0 -f Dockerfile-cuda9 .
    elif [ "$1" == "cuda9.0" ]; then
        docker build -t coolcat647/ros-pytorch:cuda9.0 -f Dockerfile-cuda9 .
    elif [ "$1" == "cuda10" ]; then
        docker build -t coolcat647/ros-pytorch:cuda10.0 -f Dockerfile-cuda10 .
    elif [ "$1" == "cuda10.0" ]; then
        docker build -t coolcat647/ros-pytorch:cuda10.0 -f Dockerfile-cuda10 .
    else
        echo -e "Please specify which cuda version your GPU support."
        echo -e "${COLOR_RED}Usage: source docker_build.sh [cuda9 | cuda10]${COLOR_NC}"
    fi
else
    echo -e "${COLOR_RED}Usage: source docker_build.sh [cuda9 | cuda10]${COLOR_NC}"
fi
