ARG ROOT_CONTAINER=ubuntu:14.04
FROM $ROOT_CONTAINER

LABEL maintainer="OpenAlea"

# Fix DL4006
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

USER root

# Configure environment
ENV NB_USER=openalea \
    NB_UID=1000 \
    SHELL=/bin/bash \
    LC_ALL=C.UTF-8 \
    LANG=C.UTF-8 \
    LANGUAGE=C.UTF-8

ENV HOME=/home/${NB_USER}

ENV DEBIAN_FRONTEND noninteractive

# Create NB_USER with name openalea user with UID=1000 and in the 'users' group
# and make sure these dirs are writable by the `users` group.
RUN echo "Creating ${NB_USER} user..." && \
    groupadd --gid ${NB_UID} ${NB_USER} && \
    useradd --create-home --gid ${NB_UID} --no-log-init --uid ${NB_UID} ${NB_USER} && \
    chmod g+w /etc/passwd 

# Install all OS dependencies 
# install  OpenGL driver required for openalea installation
RUN echo "Installing Apt-get packages..." && \
    apt-get update --fix-missing && \
    apt-get install --yes --no-install-recommends \
    wget ca-certificates sudo locales libgl1-mesa-glx run-one  \
    vim gnuplot-x11 python-matplotlib software-properties-common \
    xserver-xorg-input-all python-qt4 python-opencv subversion git && \
    apt-get -y autoclean && \
    apt-get -y autoremove && \
    rm -rf /var/lib/apt/lists/* && \
    echo "C.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen

RUN echo "auth requisite pam_deny.so" >> /etc/pam.d/su && \
    sed -i.bak -e 's/^%admin/#%admin/' /etc/sudoers && \
    sed -i.bak -e 's/^%sudo/#%sudo/' /etc/sudoers 

# Installation of OpenAlea packages
RUN add-apt-repository ppa:christophe-pradal/openalea \
    && add-apt-repository ppa:christophe-pradal/vplants

RUN apt-get update && apt-get install -y \ 
    python-setuptools \ 
    python-dev \
    python-openalea.deploy \
    python-openalea.sconsx \
    debhelper \
    libqt4-dev \
    libqt4-opengl-dev  \
    libboost-python-dev  \
    libreadline-dev \
    pkg-config \
    bison \
    flex \
    freeglut3-dev \
    ipython

WORKDIR ${HOME}

RUN git clone https://github.com/openalea/StructureAnalysis.git -b new_python_api && \
    git clone https://github.com/VirtualPlants/AML.git -b docker

EXPOSE 8888

ENTRYPOINT ["/bin/bash"]

#COPY --chown=openalea:openalea . /home/openalea
RUN cd StructureAnalysis/tool && \
   python setup.py develop && \
   cd ../../AML/amlobj && \
   python setup.py develop && \
   cd ../../StructureAnalysis/stat_tool && \
   python setup.py develop && \
   cd ../sequence_analysis && \
   python setup.py develop && \
   cd ../../AML/aml && \
   python setup.py develop && \
   cd ../../

RUN mkdir $HOME/external

RUN chown -R ${NB_USER} StructureAnalysis AML
RUN chgrp -R ${NB_UID} StructureAnalysis AML
RUN chmod 755 external && chown -R ${NB_UID} external && chgrp -R ${NB_UID} external

ENV OPENALEA_LIB="/home/openalea/AML/aml/build-scons/lib:/home/openalea/AML/amlobj/build-scons/lib:/home/openalea/StructureAnalysis/tool/build-scons/lib:/home/openalea/StructureAnalysis/sequence_analysis/build-scons/lib:/home/openalea/StructureAnalysis/stat_tool/build-scons/lib:/usr/local/lib" \
   OPENALEA_BIN="/home/openalea/AML/aml/build-scons/bin"
ENV LD_LIBRARY_PATH=${OPENALEA_LIB} \
    PATH=$PATH:${OPENALEA_BIN}

RUN echo 'OPENALEA_LIB="/home/openalea/AML/aml/build-scons/lib:/home/openalea/AML/amlobj/build-scons/lib:/home/openalea/StructureAnalysis/tool/build-scons/lib:/home/openalea/StructureAnalysis/sequence_analysis/build-scons/lib:/home/openalea/StructureAnalysis/stat_tool/build-scons/lib:/usr/local/lib"' >> ${HOME}/.bashrc

# root
USER ${NB_USER}
