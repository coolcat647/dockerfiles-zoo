# This image build for cuda8.0 + cudnn7 + ros kinetic

FROM nvidia/cuda:8.0-cudnn7-devel-ubuntu16.04

# Set default shell to bash
SHELL ["/bin/bash", "-c"]
ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive
ENV ROS_DISTRO kinetic
WORKDIR ${HOME}
RUN echo "Preparing system environment..."
RUN mv /root/.bashrc /root/bashrc.bak && \
    touch /root/.bashrc
RUN apt-get update -qq > /dev/null && apt-get install -y -qq sudo wget lsb-release iputils-ping > /dev/null && \
    apt-get install -y -qq build-essential libopencv-dev python-opencv libeigen3-dev vim htop sshfs nfs-common python-dev git python-pip python-all-dev libatlas-base-dev gfortran > /dev/null && \
    apt-get install -y -qq libopenblas-dev mpg123 > /dev/null && \
    rm -rf /var/lib/apt/lists/*
RUN wget -q https://bootstrap.pypa.io/get-pip.py && \
    python get-pip.py && \
    export PATH=/usr/local/bin:$PATH && \
    rm get-pip.py

RUN pip install --upgrade pip

# RUN git clone https://github.com/voutcn/g2o.git && cd g2o && sh init.sh

# ADD pip install pyopenssl before ROS install to fix build issue
RUN pip install -q -U bitarray pyzmq ujson requests gunicorn pymysql numpy pandas scipy scikit-learn gTTs awscli numba chardet pyopenssl > /dev/null
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list' && \
    apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654 && \
    apt-get update -qq && \
    apt-get install -y -qq ros-kinetic-desktop-full && \
    rosdep init && \
    rosdep update && \
    echo "source /opt/ros/kinetic/setup.bash" >> /root/.bashrc && \
    source /root/.bashrc
# supervisor
# RUN apt-get install -y openssh-server apache2 supervisor
# RUN mkdir -p /var/run/sshd
# RUN mkdir -p /var/log/supervisor
# COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
EXPOSE 22 80 8888
#CMD ["/usr/bin/supervisord"]
#  -------------------------------------------------- caffe --------------------------------------------------
RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        cmake \
        git \
        wget \
        libatlas-base-dev \
        libboost-all-dev \
        libgflags-dev \
        libgoogle-glog-dev \
        libhdf5-serial-dev \
        libleveldb-dev \
        liblmdb-dev \
        libopencv-dev \
        libprotobuf-dev \
        libsnappy-dev \
        protobuf-compiler \
        python-dev \
        python-numpy \
        python-pip \
        python-setuptools \
        python-scipy && \
    rm -rf /var/lib/apt/lists/*
ENV CAFFE_ROOT=/opt/caffe
WORKDIR $CAFFE_ROOT
# FIXME: use ARG instead of ENV once DockerHub supports this
# https://github.com/docker/hub-feedback/issues/460

ENV CLONE_TAG=ssd
RUN git clone -b ${CLONE_TAG} --depth 1 https://github.com/weiliu89/caffe . && \
    pip install --upgrade pip && \
    cd python && for req in $(cat requirements.txt) pydot; do pip install $req; done && cd .. && \
    git clone https://github.com/NVIDIA/nccl.git && cd nccl && make -j install && cd .. && rm -rf nccl && \
    mkdir build && cd build && \
    cmake -DUSE_CUDNN=1 -DUSE_NCCL=1 .. && \
    make -j"$(nproc)"
ENV PYCAFFE_ROOT $CAFFE_ROOT/python
ENV PYTHONPATH $PYCAFFE_ROOT:$PYTHONPATH
ENV PATH $CAFFE_ROOT/build/tools:$PYCAFFE_ROOT:$PATH
RUN echo "$CAFFE_ROOT/build/lib" >> /etc/ld.so.conf.d/caffe.conf && ldconfig
WORKDIR /workspace
RUN sudo pip install jupyter gdown

# Download Pre-Trained Model
#RUN cd $CAFFE_ROOT && gdown --id 0BzKzrI_SkD1_WVVTSmQxU0dVRzA && tar -xvf models_VGGNet_VOC0712_SSD_300x300.tar.gz && mv models/VGGNet/VOC0712/SSD_300x300/VGG_VOC0712_SSD_300x300_iter_120000.caffemodel models/VGGNet/VOC0712/SSD_300x300/VGG_VOC0712_SSD_300x300_iter_60000.caffemodel  

#  -------------------------------------------------- caffe --------------------------------------------------

