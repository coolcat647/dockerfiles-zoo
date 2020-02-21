FROM nvcr.io/nvidia/l4t-base:r32.3.1
# FROM arm64v8/ubuntu:bionic

SHELL ["/bin/bash","-c"]

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y --no-install-recommends make g++
# Prerequisite linux tool for ROS 
RUN apt-get update && \
    apt-get install -y wget lsb-release iputils-ping \
                       build-essential vim htop sshfs \
                       nfs-common git net-tools && \
    rm -rf /var/lib/apt/lists/*


# ROS installation: melodic
ENV ROS_DISTRO melodic
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list' && \
    apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654 && \
    apt-get update && apt-get install -y -qq \
    apt-utils \
    ros-${ROS_DISTRO}-desktop-full && \
    rosdep init && \
    rosdep update && \
    echo "source /opt/ros/${ROS_DISTRO}/setup.bash" >> /root/.bashrc && \
    source /root/.bashrc


# Jupyter installation
RUN curl -sL https://deb.nodesource.com/setup_11.x | bash
RUN apt-get update && apt-get install -y python-pip python3-pip  nodejs
RUN pip3 install Cython jupyter numpy==1.18.0
RUN pip3 install ipywidgets bqplot pyyaml setuptools==41.0.0 

# Tensorflow 1.15.0 installation: cuda 10.0 + python 3 + pip3
RUN wget -q https://developer.download.nvidia.com/compute/redist/jp/v42/tensorflow-gpu/tensorflow_gpu-1.15.0+nv19.11-cp36-cp36m-linux_aarch64.whl -O tensorflow_gpu-1.15.0+nv19.11-cp36-cp36m-linux_aarch64.whl && \
     pip3 install tensorflow_gpu-1.15.0+nv19.11-cp36-cp36m-linux_aarch64.whl
RUN rm -rf tensorflow_gpu-1.15.0+nv19.11-cp36-cp36m-linux_aarch64.whl
#RUN pip3 install --extra-index-url https://developer.download.nvidia.com/compute/redist/jp/v42 tensorflow-gpu==1.15.0+nv19.11

EXPOSE 8888

CMD ["bash"]
