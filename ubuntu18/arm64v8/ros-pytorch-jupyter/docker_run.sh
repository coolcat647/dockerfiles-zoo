#!/usr/bin/env sh

# Setup the style of color
COLOR_RED='\033[0;31m'
COLOR_YELLOW='\033[0;33m'
COLOR_NC='\033[0m'

# Find current directory and transfer it to container directory for Docker
jupyter_port="8889"
current_dir="$(pwd)"
host_dir="${HOME}/"
container_dir="/root/"
goal_dir=${current_dir//$host_dir/$container_dir}

# export env
export JUPYTER_PORT="${jupyter_port}"

ret_code="$(command -v nvidia-docker)"
if [ -z "$ret_code" ]
then
    printf "${COLOR_YELLOW}\"nvidia-docker\" is not found, so substitute docker. ${COLOR_NC}\n"
    docker run -it --rm --net=host \
                            -v ${current_dir}:${goal_dir} \
                            -e DISPLAY=$DISPLAY \
                            -e JUPYTER_PORT="${jupyter_port}" \
                            -v /tmp/.X11-unix/:/tmp/.X11-unix \
                            -w ${goal_dir} \
                            --name ros-pytorch \
                            coolcat647/ros-pytorch:arm64v8
else
    printf "Run \"nvidia-docker\"\n"
    nvidia-docker run -it --rm --net=host \
                            -v ${current_dir}:${goal_dir} \
                            -e DISPLAY=$DISPLAY \
                            -e JUPYTER_PORT="${jupyter_port}" \
                            -v /tmp/.X11-unix/:/tmp/.X11-unix \
                            -w ${goal_dir} \
                            --name ros-pytorch \
                            coolcat647/ros-pytorch:arm64v8
fi
