ARG BASE_CONTAINER=openalea/base
FROM $BASE_CONTAINER

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

USER root
RUN apt-get update --yes && \
    apt-get install --yes --no-install-recommends \
    git && \
    apt-get clean && rm -rf /var/lib/apt/lists/* 

USER ${NB_UID}

RUN conda install --quiet --yes \
    'matplotlib' \
    'voila' \
    'voila-vuetify' \
    'cufflinks-py' \
    'ipyvuetify' \
    'plotly' && \
    conda clean --all -f -y && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

RUN git clone https://github.com/openalea-incubator/oawidgets.git && \
	cd oawidgets && python setup.py install && cd ..

RUN git clone https://github.com/openalea/strawberry.git && \
	cd strawberry && python setup.py install && cd ..

RUN mkdir "/home/${NB_USER}/work/dashboard_files" && \
	mkdir "/home/${NB_USER}/work/notebooks" && \
	cp strawberry/share/data/*.mtg /home/${NB_USER}/work/dashboard_files && \
	cp strawberry/example/tutorials/*.ipynb /home/${NB_USER}/work/notebooks && \
	rm -r strawberry oawidgets
