# FROM nvidia/cudagl:10.0-devel-ubuntu16.04
FROM nvidia/cudagl:9.0-devel-ubuntu16.04
# FROM osrf/ros:kinetic-desktop-xenial

SHELL ["/bin/bash","-c"]

# Prerequisite linux tool for ROS 
RUN apt-get update -qq > /dev/null && apt-get install -y -qq sudo wget lsb-release iputils-ping > /dev/null && \
    apt-get install -y -qq build-essential vim htop sshfs nfs-common git net-tools && \
    rm -rf /var/lib/apt/lists/*

# ROS installation: kinetic
ENV ROS_DISTRO kinetic
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list' && \
    apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654 && \
    apt-get update && apt-get install -y \
        apt-utils \
        ros-${ROS_DISTRO}-desktop-full \
        ros-${ROS_DISTRO}-serial && \
    rosdep init && \
    rosdep update && \
    echo "source /opt/ros/${ROS_DISTRO}/setup.bash" >> /root/.bashrc && \
    source /root/.bashrc


# ROS workspace in container
ENV CATKIN_WS=/root/catkin_ws
RUN mkdir -p $CATKIN_WS/src
WORKDIR $CATKIN_WS/src

RUN source /opt/ros/${ROS_DISTRO}/setup.bash \
    && apt-get update \
    && cd $CATKIN_WS \
    && catkin_make


# Jupyter installation
RUN apt-get update && apt-get install -y python-pip
RUN pip install pip==9.0.1
RUN apt-get -y install curl
RUN curl -sL https://deb.nodesource.com/setup_11.x | bash
RUN apt-get -y install nodejs

RUN pip install jupyter ipywidgets jupyterlab bqplot pyyaml jupyros numpy==1.12.0
RUN jupyter labextension install @jupyter-widgets/jupyterlab-manager
RUN jupyter labextension install jupyter-ros
RUN jupyter nbextension enable --py --sys-prefix jupyros
RUN jupyter nbextension enable --py --sys-prefix widgetsnbextension

# Pytorch installation: cuda 9.0 + python 2.7 + pip
RUN pip install --no-cache-dir torch==1.0.1 -f https://download.pytorch.org/whl/cu90/stable torchvision typing
# Pytorch installation: cuda 10.0 + python 2.7 + pip
# RUN pip install --no-cache-dir torch torchvision

# packages to run examples
RUN pip install sidecar gdown h5py opencv-python
RUN pip install --upgrade cryptography matplotlib
RUN python -m easy_install --upgrade pyOpenSSL 
RUN jupyter labextension install @jupyter-widgets/jupyterlab-sidecar

RUN apt-get install -y ros-${ROS_DISTRO}-teb-local-planner ros-${ROS_DISTRO}-interactive-marker-proxy ros-${ROS_DISTRO}-tf2-ros ros-${ROS_DISTRO}-rosbridge-server
RUN git clone https://github.com/RobotWebTools/tf2_web_republisher /root/catkin_ws/src/tf2_web_republisher/

WORKDIR $CATKIN_WS/src
RUN source /opt/ros/${ROS_DISTRO}/setup.bash \
    && cd $CATKIN_WS \
    && catkin_make \
    && apt-get install ros-${ROS_DISTRO}-serial
# RUN /bin/bash -c '. /opt/ros/kinetic/setup.bash; cd /root/catkin_ws; catkin_make'

# RUN git clone https://github.com/ARG-NCTU/jupyter-ros.git /root/jupyter-ros/

EXPOSE 8888

ENV QT_X11_NO_MITSHM=1

# COPY ./ros_catkin_entrypoint.sh /
# ENTRYPOINT ["/ros_catkin_entrypoint.sh"]
CMD ["bash"]
