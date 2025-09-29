ARG ROOT_CONTAINER=ubuntu:20.04
FROM $ROOT_CONTAINER

LABEL maintainer="OpenAlea"

# Fix DL4006
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

USER root

# Package Manager and Python implementation to use (https://github.com/conda-forge/miniforge)
# - conda only: either Miniforge3 to use Python or Miniforge-pypy3 to use PyPy
# - conda + mamba: either Mambaforge to use Python or Mambaforge-pypy3 to use PyPy
ARG miniforge_python=Mambaforge

# Configure environment
ENV CONDA_VERSION=22.11.1-4 \
    CONDA_DIR=/opt/conda \
    CONDA_ENV=openalea \
    NB_USER=openalea \
    NB_UID=1000 \
    SHELL=/bin/bash \
    LC_ALL=C.UTF-8 \
    LANG=C.UTF-8 \
    LANGUAGE=C.UTF-8

ENV NB_PYTHON_PREFIX=${CONDA_DIR}/envs/${CONDA_ENV} \
    PATH=${NB_PYTHON_PREFIX}/bin:${CONDA_DIR}/bin:${PATH} \
    HOME=/home/${NB_USER}

ENV DEBIAN_FRONTEND noninteractive

# Create NB_USER with name openalea user with UID=1000 and in the 'users' group
# and make sure these dirs are writable by the `users` group.
RUN echo "Creating ${NB_USER} user..." && \
    groupadd --gid ${NB_UID} ${NB_USER} && \
    useradd --create-home --gid ${NB_UID} --no-log-init --uid ${NB_UID} ${NB_USER} && \
    echo ". ${CONDA_DIR}/etc/profile.d/conda.sh ; conda activate ${CONDA_ENV}" > /etc/profile.d/init_conda.sh && \
    mkdir -p ${CONDA_DIR} && \
    chown -R ${NB_USER}:${NB_USER} ${CONDA_DIR}/.. && \
    chmod g+w /etc/passwd

# SEE: https://github.com/phusion/baseimage-docker/issues/58
ARG DEBIAN_FRONTEND=noninteractive

# Install all OS dependencies
# install  OpenGL driver required for openalea installation
RUN echo "Installing Apt-get packages..." && \
    apt-get update --fix-missing && \
    apt-get install --yes --no-install-recommends \
    wget ca-certificates sudo locales libgl1-mesa-glx run-one && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    echo "C.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen

RUN echo "auth requisite pam_deny.so" >> /etc/pam.d/su && \
    sed -i.bak -e 's/^%admin/#%admin/' /etc/sudoers && \
    sed -i.bak -e 's/^%sudo/#%sudo/' /etc/sudoers

USER ${NB_USER}
WORKDIR ${HOME}

COPY ./Fortinet_CA_SSL.crt ${HOME}/

# Prerequisites installation: conda, mamba, pip, tini
RUN echo "Installing Miniforge..." && \
    set -x && \
    # Miniforge installer
    miniforge_arch=$(uname -m) && \
    export miniforge_arch && \
    if [ "$miniforge_arch" == "aarm64" ]; then \
      miniforge_arch="arm64"; \
    fi; \
    URL="https://github.com/conda-forge/miniforge/releases/download/${CONDA_VERSION}/${miniforge_python}-${CONDA_VERSION}-$(uname)-${miniforge_arch}.sh" && \
    wget --quiet ${URL} -O miniforge.sh && \
    /bin/bash miniforge.sh -f -b -p ${CONDA_DIR} && \
    rm miniforge.sh && \
    # Conda configuration see https://conda.io/projects/conda/en/latest/configuration.html
    echo "conda ${CONDA_VERSION}" >> "${CONDA_DIR}/conda-meta/pinned" && \
    conda config --system --set auto_update_conda false && \
    conda config --system --set show_channel_urls true && \
    conda config --set ssl_verify ${HOME}/Fortinet_CA_SSL.crt && \
    conda update --all --quiet --yes && \
    mamba clean -afy && \
    rm -rf "/home/${NB_USER}/.cache/yarn"

EXPOSE 8888
ENTRYPOINT ["/opt/start"]


ONBUILD USER root
ONBUILD COPY --chown=openalea:openalea . /home/openalea

ONBUILD ARG DEBIAN_FRONTEND=noninteractive

ONBUILD RUN echo "Checking for 'apt.txt'..." \
        ; if test -f "apt.txt" ; then \
        apt-get update --fix-missing \
        && xargs -a apt.txt apt-get install -y \
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/* \
        ; fi

# Copy jupyter_notebook_config.py to /etc/jupyter
ONBUILD RUN echo "Checking for 'jupyter_notebook_config.py'..." \
        ; if test -f "jupyter_notebook_config.py" ; then \
        mkdir -p /etc/jupyter \
        && cp jupyter_notebook_config.py /etc/jupyter \
        ; fi

ONBUILD USER ${NB_USER}

# Create "notebook" conda environment
ONBUILD RUN echo "Checking for 'conda-linux-64.lock' or 'environment.yml'..." \
        ; if test -f "conda-linux-64.lock" ; then \
        mamba create --name ${CONDA_ENV} --file conda-linux-64.lock \
        ; elif test -f "environment.yml" ; then \
        mamba env create --name ${CONDA_ENV} -f environment.yml  \
        ; else echo "No conda-linux-64.lock or environment.yml!" \
        ; fi \
        && mamba clean -yaf \
        && find ${CONDA_DIR} -follow -type f -name '*.a' -delete \
        && find ${CONDA_DIR} -follow -type f -name '*.pyc' -delete \
        && find ${CONDA_DIR} -follow -type f -name '*.js.map' -delete \
        ; if [ -d ${NB_PYTHON_PREFIX}/lib/python*/site-packages/bokeh/server/static ]; then \
        find ${NB_PYTHON_PREFIX}/lib/python*/site-packages/bokeh/server/static -follow -type f -name '*.js' ! -name '*.min.js' -delete \
        ; fi

# Install pip packages
# remove cache https://github.com/pypa/pip/pull/6391 ?
ONBUILD RUN echo "Checking for pip 'requirements.txt'..." \
        ; if test -f "requirements.txt" ; then \
        ${NB_PYTHON_PREFIX}/bin/pip install --no-cache-dir -r requirements.txt \
        ; fi

# Install packages from source
ONBUILD RUN echo "Checking for 'sources.txt' to install from git repo..." \
        ; if test -f "sources.txt" ; then \
        for p in `cat sources.txt`; do \
        git clone $p ; \
        cd `basename $p .git`; ${NB_PYTHON_PREFIX}/bin/python setup.py install; cd .. \
        ; done \
        ; fi

# Run postBuild script within environment as root
ONBUILD USER root
ONBUILD RUN echo "Checking for 'postBuild_root'..." \
        ; if test -f "postBuild_root" ; then \
        chmod +x postBuild_root \
        && ./postBuild_root \
        && rm -rf /tmp/* \
        && rm -rf ${HOME}/.cache ${HOME}/.npm ${HOME}/.yarn \
        && rm -rf ${NB_PYTHON_PREFIX}/share/jupyter/lab/staging \
        && find ${CONDA_DIR} -follow -type f -name '*.a' -delete \
        && find ${CONDA_DIR} -follow -type f -name '*.pyc' -delete \
        && find ${CONDA_DIR} -follow -type f -name '*.js.map' -delete \
        ; fi

# Run postBuild script within environment
ONBUILD USER ${NB_USER}
ONBUILD RUN echo "Checking for 'postBuild'..." \
        ; if test -f "postBuild" ; then \
        chmod +x postBuild \
        && ./postBuild \
        && rm -rf /tmp/* \
        && rm -rf ${HOME}/.cache ${HOME}/.npm ${HOME}/.yarn \
        && rm -rf ${NB_PYTHON_PREFIX}/share/jupyter/lab/staging \
        && find ${CONDA_DIR} -follow -type f -name '*.a' -delete \
        && find ${CONDA_DIR} -follow -type f -name '*.pyc' -delete \
        && find ${CONDA_DIR} -follow -type f -name '*.js.map' -delete \
        ; fi

# Overwrite start entrypoint script if present
ONBUILD RUN echo "Checking for 'start'..." \
        ; if test -f "start" ; then \
        chmod +x start \
        && cp start /opt/start \
        ; fi
