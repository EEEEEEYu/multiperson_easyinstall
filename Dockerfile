# After building docker image, follow the current instructions to run the container!
# https://docs.google.com/document/d/1-QxKYc98Jts67yGqR-jXCZbBvZQqMF1vyr2s0lpI-Nc/edit?usp=sharing

# Refer to this page: https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html#ubuntu
FROM nvidia/cuda:10.0-devel-ubuntu18.04

################################### Installing conda ###################################
# Install base utilities
# See https://github.com/NVIDIA/nvidia-docker/issues/1631
#RUN rm /etc/apt/sources.list.d/cuda.list
#RUN rm /etc/apt/sources.list.d/nvidia-ml.list
#RUN apt-key del 7fa2af80
#RUN apt-get update && apt-get install -y --no-install-recommends wget
#RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-keyring_1.0-1_all.deb
#RUN dpkg -i cuda-keyring_1.0-1_all.deb

RUN apt-get update && \
    apt-get install -y build-essential  && \
    apt-get install -y wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install miniconda
ENV CONDA_DIR /opt/conda
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
     /bin/bash ~/miniconda.sh -b -p /opt/conda

# Put conda in path so we can use conda activate
ENV PATH=$CONDA_DIR/bin:$PATH

################################### Install git, gcc6, Clone and Compile ###################################
RUN apt-get update && \
	apt-get install -y git && \
	git clone https://github.com/EEEEEEYu/multiperson_easyinstall.git


ENV CUDA_HOME /usr/local/cuda-10.0
WORKDIR multiperson_easyinstall

RUN conda env update -n base -f environment.yml
WORKDIR neural_renderer
RUN ls $CUDA_HOME/lib64
RUN python3 setup.py install
WORKDIR ../mmcv
RUN python3 setup.py install
WORKDIR ../mmdetection
RUN bash compile.sh
RUN python3 setup.py develop
WORKDIR ../sdf
RUN python3 setup.py install
WORKDIR ..
RUN apt-get install -y libsm6 libxext6 libxrender-dev libosmesa6-dev freeglut3-dev nvidia-utils-525

