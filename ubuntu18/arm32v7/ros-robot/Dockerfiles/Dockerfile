FROM arm32v7/ros:melodic-perception
# FROM arm64v8/ubuntu:bionic

SHELL ["/bin/bash","-c"]

# ARG DEBIAN_FRONTEND=noninteractive
# RUN apt-get update && apt-get install -y --no-install-recommends make g++
# # Prerequisite linux tool for ROS 
# RUN apt-get update && \
#     apt-get install -y wget lsb-release iputils-ping \
#                        build-essential vim htop sshfs \
#                        nfs-common git net-tools && \
#     rm -rf /var/lib/apt/lists/*
ENV ROS_DISTRO melodic
RUN apt-get update && apt-get install -y sudo python-pip \
    ros-${ROS_DISTRO}-tf \
    ros-${ROS_DISTRO}-tf-conversions \
    ros-${ROS_DISTRO}-pcl-ros \
    ros-${ROS_DISTRO}-teb-local-planner-tutorials \
    ros-${ROS_DISTRO}-stage-ros \
    ros-${ROS_DISTRO}-teleop-twist-joy

RUN pip install simple_pid \
    Adafruit_GPIO



# Create a new user
ENV USER developer
RUN useradd -m -d /home/${USER} ${USER} -p "" \
 && chown -R ${USER} /home/${USER} /root/ && adduser ${USER} sudo
USER ${USER}

RUN sudo rm /etc/ros/rosdep/sources.list.d/20-default.list && \
    sudo rosdep init && rosdep update && \
    echo "source /opt/ros/${ROS_DISTRO}/setup.bash" >> /home/${USER}/.bashrc && \
    source /home/${USER}/.bashrc
    

# ROS installation: melodic
# ENV ROS_DISTRO melodic
# RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list' && \
#     apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654 && \
#     apt-get update && apt-get install -y -qq \
#     apt-utils \
#     ros-${ROS_DISTRO}-desktop-full && \
#     rosdep init && \
#     rosdep update && \
#     echo "source /opt/ros/${ROS_DISTRO}/setup.bash" >> /root/.bashrc && \
#     source /root/.bashrc


# Jupyter installation
# RUN curl -sL https://deb.nodesource.com/setup_11.x | bash
# RUN apt-get update && apt-get install -y python-pip  nodejs
# RUN pip install pip==9.0.1

# RUN pip install jupyter ipywidgets jupyterlab bqplot pyyaml jupyros numpy
# RUN jupyter labextension install @jupyter-widgets/jupyterlab-manager && \
#     jupyter labextension install jupyter-ros && \
#     jupyter nbextension enable --py --sys-prefix jupyros && \
#     jupyter nbextension enable --py --sys-prefix widgetsnbextension


# Pytorch installation: cuda 10.0 + python 2.7 + pip
# RUN pip install --no-cache-dir torch torchvision
# RUN wget -q https://nvidia.box.com/shared/static/8gcxrmcc6q4oc7xsoybk5wb26rkwugme.whl -O torch-1.2.0a0+8554416-cp27-cp27mu-linux_aarch64.whl && \
#     pip install --no-cache-dir torch-1.2.0a0+8554416-cp27-cp27mu-linux_aarch64.whl

EXPOSE 8888

CMD ["bash"]
