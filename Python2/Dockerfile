## Building command:
## docker build --pull --rm -f "Dockerfile" -t openalea/python2:latest "."

FROM ubuntu:14.04

USER root

SHELL ["/bin/bash", "--login", "-c"]

# Installation of necessary packages
RUN apt-get update
RUN apt-get install --no-install-recommends -y \
    gnuplot-x11 \
    python-matplotlib \
    software-properties-common \
    xserver-xorg-input-all \
    python-qt4 \
    python-opencv \
    subversion \
    git
RUN apt-get -y autoclean \
    && apt-get -y autoremove \
    && rm -rf /var/lib/apt/lists/*

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
