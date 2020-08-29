#!/usr/bin/env sh
xhost +local:docker

# Setup the style of color
COLOR_RED='\033[0;31m'
COLOR_YELLOW='\033[0;33m'
COLOR_NC='\033[0m'

#
# Check the command 'nvidia-docker' existed or not
#
ret_code="$(command -v nvidia-docker)"
if [ -z "$ret_code" ]; then
    DOCKER_CMD="docker"
else
    DOCKER_CMD="nvidia-docker"
fi


#
# Specify cuda version
#
if [ $# -gt 0 ]; then
    if [[ "$1" == "cuda10" || "$1" == "cuda10.0" ]] ; then
        echo -e "RUN: \"${DOCKER_CMD}\""
        DOCKER_TAG="cuda10.0"
    elif [ "$1" == "same" ] ; then
        echo -e "RUN: \"docker exec\""
    else
        echo -e "Please specify which cuda version your GPU support."
        echo -e "${COLOR_RED}Usage: source docker_run.sh [cuda10 | same]${COLOR_NC}"
    fi
else
    echo -e "${COLOR_RED}Usage: source docker_run.sh [cuda10| same]${COLOR_NC}"
fi

# Find current directory and transfer it to container directory for Docker
jupyter_port="8888"
current_dir="$(pwd)"
host_dir="${HOME}/"
container_dir="/root/"
goal_dir=${current_dir//$host_dir/$container_dir}
#echo "goal_dir: \"${goal_dir}\""

# export env
export JUPYTER_PORT="${jupyter_port}"

#
# Execute command
#
if [ $# -gt 0 ]; then
    if [ "$1" == "same" ]; then
        docker exec -it ubuntu18-ros-pytorch bash
    else
        ${DOCKER_CMD} run --name ubuntu18-ros-pytorch --rm -it --net=host --privileged -v /dev:/dev \
            -e JUPYTER_PORT="${jupyter_port}" \
            -e DISPLAY=$DISPLAY \
            -v /etc/localtime:/etc/localtime:ro -v /var/run/docker.sock:/var/run/docker.sock \
            -v ${current_dir}:${goal_dir} \
            -v /tmp/.X11-unix/:/tmp/.X11-unix:rw \
            -w ${goal_dir} \
            --device=/dev/dri:/dev/dri \
            --device=/dev/nvhost-ctrl \
            --device=/dev/nvhost-ctrl-gpu \
            --device=/dev/nvhost-prof-gpu \
            --device=/dev/nvmap \
            --device=/dev/nvhost-gpu \
            --device=/dev/nvhost-as-gpu \
            -v /dev/bus/usb:/dev/bus/usb \
            coolcat647/ubuntu18-ros-pytorch:${DOCKER_TAG}      
    fi
else
    echo "please provide docker tag name."
fi
