#!/usr/bin/env sh

# Setup the style of color
COLOR_RED='\033[0;31m'
COLOR_YELLOW='\033[0;33m'
COLOR_NC='\033[0m'

# Specify cuda version
if [ $# -gt 0 ]; then
    if [ "$1" == "cuda8" ]; then
        docker_tag="cuda8.0"
    elif [ "$1" == "cuda8.0" ]; then
        docker_tag="cuda8.0"
    elif [ "$1" == "cuda10" ]; then
        docker_tag="cuda10.0"
    elif [ "$1" == "cuda10.0" ]; then
        docker_tag="cuda10.0"
    
    else
        echo -e "Please specify which cuda version your GPU support."
        echo -e "${COLOR_RED}Usage: source docker_run.sh [cuda8 | cuda10]${COLOR_NC}"
    fi
else
    echo -e "${COLOR_RED}Usage: source docker_run.sh [cuda8 | cuda10]${COLOR_NC}"
fi

# Find current directory and transfer it to container directory for Docker
jupyter_port="8889"
current_dir="$(pwd)"
host_dir="${HOME}/"
container_dir="/root/"
goal_dir=${current_dir//$host_dir/$container_dir}
#echo "goal_dir: \"${goal_dir}\""

# export env
export JUPYTER_PORT="${jupyter_port}"

# Check the command 'nvidia-docker' is existing or not
ret_code="$(command -v nvidia-docker)"
if [ -z "$ret_code" ]
then
    printf "${COLOR_YELLOW}\"nvidia-docker\" is not found, so substitute docker. ${COLOR_NC}\n"

    docker run -it --rm -v ${current_dir}:${goal_dir} \
                        -p "${jupyter_port}":"${jupyter_port}" \
                        -w "${goal_dir}" \
                        -e JUPYTER_PORT="${jupyter_port}" \
                        --name pytorch-jupyter-test \
                        coolcat647/pytorch-jupyter:${docker_tag}
else
    printf "Run \"nvidia-docker\"\n"
    nvidia-docker run -it --rm -v ${current_dir}:${goal_dir} \
                               -p "${jupyter_port}":"${jupyter_port}" \
                               -w ${goal_dir} \
                               -e JUPYTER_PORT="${jupyter_port}" \
                               --name pytorch-jupyter-test \
                               coolcat647/pytorch-jupyter:${docker_tag}
fi
