FROM thomasarsouze/base-openalea:latest

USER ${NB_USER}

RUN mkdir "/home/${NB_USER}/work/" && \
    mkdir "/home/${NB_USER}/work/dashboard_files" && \
  	mkdir "/home/${NB_USER}/work/notebooks" && \
  	mkdir "/home/${NB_USER}/work/application" && \
	git clone --depth 1 --no-checkout https://github.com/openalea/strawberry.git && \
	cd strawberry && \
	git sparse-checkout set example share/data src/openalea/strawberry/application && \
	cd /home/${NB_USER} && \
    cp strawberry/share/data/*.mtg /home/${NB_USER}/work/dashboard_files && \
  	cp strawberry/example/tutorials/*.ipynb /home/${NB_USER}/work/notebooks && \
  	cp strawberry/src/openalea/strawberry/application/* /home/${NB_USER}/work/application && \
    rm -rf strawberry