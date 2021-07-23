# Ubuntu 14.04 (Trusty)

FROM ubuntu:14.04

USER root

SHELL ["/bin/bash", "--login", "-c"]

# Installation of necessary packages
RUN apt-get update
RUN apt-get install -y \
    python-matplotlib \
    software-properties-common \
    xserver-xorg-input-all \
    python-qt4 \
    python-opencv \
    subversion \
    git
RUN apt-get -y autoclean \
    && apt-get -y autoremove

# Installation of OpenAlea packages
RUN add-apt-repository ppa:christophe-pradal/openalea \
    && add-apt-repository ppa:christophe-pradal/vplants \
    && add-apt-repository ppa:christophe-pradal/alinea

RUN apt-get update && apt-get install -y python-openalea python-vplants python-alinea


# Define a "User001" user who doesn't have root permission.
RUN useradd -rm -d /home/User001 -s /bin/bash -g root -G sudo -u 1000 User001
USER User001
RUN alea_config
WORKDIR /home/User001
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib/python2.7/dist-packages/lib/


#### Protocol to launch the Docker in you machine ####

# docker build -t openalea .
# xhost +
# docker run -it --env QT_X11_NO_MITSHM=1 -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix openalea
