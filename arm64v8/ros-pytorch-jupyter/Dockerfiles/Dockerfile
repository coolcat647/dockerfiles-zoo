FROM nvcr.io/nvidia/l4t-base:r32.2
# FROM arm64v8/ubuntu:bionic

ARG DEBIAN_FRONTEND=noninteractive

# Prerequisite linux tool for ROS 
RUN apt-get update -qq > /dev/null && apt-get install -y -qq sudo wget lsb-release iputils-ping > /dev/null && \
    apt-get install -y -qq build-essential vim htop sshfs nfs-common git && \
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
RUN apt-get update && apt-get install -y python-pip  nodejs
RUN pip install pip==9.0.1

RUN pip install jupyter ipywidgets jupyterlab bqplot pyyaml jupyros numpy
RUN jupyter labextension install @jupyter-widgets/jupyterlab-manager && \
    jupyter labextension install jupyter-ros && \
    jupyter nbextension enable --py --sys-prefix jupyros && \
    jupyter nbextension enable --py --sys-prefix widgetsnbextension


# Pytorch installation: cuda 10.0 + python 2.7 + pip
# RUN pip install --no-cache-dir torch torchvision
RUN wget -q https://nvidia.box.com/shared/static/8gcxrmcc6q4oc7xsoybk5wb26rkwugme.whl -O torch-1.2.0a0+8554416-cp27-cp27mu-linux_aarch64.whl && \
    pip install --no-cache-dir torch-1.2.0a0+8554416-cp27-cp27mu-linux_aarch64.whl

EXPOSE 8888

CMD ["bash"]