# Makefile for convenience, (doesn't look for command outputs)
.PHONY: all
all: base-openalea notebook-openalea hydroroot-openalea strawberry-openalea fullstack-openalea structureanalysis-openalea
DOCKER_USER=jbduranddocker
TESTDIR=/home/openalea

.PHONY: base-openalea
base-openalea :
	ln -s base-openalea/Dockerfile ./Dockerfile; \
	cd base-openalea ; \
	# docker build --no-cache --progress=plain -t ${DOCKER_USER}/base-openalea:latest .
	sudo docker build --no-cache -t ${DOCKER_USER}/base-openalea:latest . ;\
	rm ./Dockerfile

.PHONY: notebook-openalea
notebook-openalea : base-openalea
	cd notebook-openalea ; \
	conda-lock lock --mamba -f environment.yml -p linux-64; \
	../list_packages.sh | sort > packages.txt; \
	docker build -t ${DOCKER_USER}/notebook-openalea:latest . ; \
	cd .. ; \
	docker run --rm -w ${TESTDIR} -v ${PWD}:${TESTDIR} ${DOCKER_USER}/notebook-openalea:latest ./run_tests.sh notebook-openalea

.PHONY: hydroroot-openalea
hydroroot-openalea : base-openalea
	cd hydroroot-openalea ; \
	conda-lock lock --mamba -f environment.yml -p linux-64; \
	../list_packages.sh | sort > packages.txt; \
	docker build -t ${DOCKER_USER}/hydroroot-openalea:latest . ; \
	cd .. ; \
	docker run --rm -w ${TESTDIR} -v ${PWD}:${TESTDIR} ${DOCKER_USER}/hydroroot-openalea:latest ./run_tests.sh hydroroot-openalea

.PHONY: strawberry-openalea
strawberry-openalea : base-openalea
	cd strawberry-openalea ; \
	conda-lock lock --mamba -f environment.yml -p linux-64; \
	../list_packages.sh | sort > packages.txt; \
	docker build -t ${DOCKER_USER}/strawberry-openalea:latest . ; \
	cd .. ; \
	docker run --rm -w ${TESTDIR} -v ${PWD}:${TESTDIR} ${DOCKER_USER}/strawberry-openalea:latest ./run_tests.sh strawberry-openalea

.PHONY: fullstack-openalea
fullstack-openalea : base-openalea
	cd fullstack-openalea ; \
	conda-lock lock --mamba -f environment.yml -p linux-64; \
	../list_packages.sh | sort > packages.txt; \
	docker build -t ${DOCKER_USER}/fullstack-openalea:latest . ; \
	cd .. ; \
	docker run --rm -w ${TESTDIR} -v ${PWD}:${TESTDIR} ${DOCKER_USER}/fullstack-openalea:latest ./run_tests.sh fullstack-openalea

.PHONY: plantscan3d-openalea
plantscan3d-openalea : base-openalea
	cd plantscan3d-openalea ; \
	conda-lock lock --mamba -f environment.yml -p linux-64; \
	../list_packages.sh | sort > packages.txt; \
	docker build -t ${DOCKER_USER}/plantscan3d-openalea:latest . ; \
	cd .. ; \
	docker run --rm -w ${TESTDIR} -v ${PWD}:${TESTDIR} ${DOCKER_USER}/plantscan3d-openalea:latest ./run_tests.sh plantscan3d-openalea

.PHONY: structureanalysis-openalea
structureanalysis-openalea : base-openalea
	ln -s base-openalea/Dockerfile ./Dockerfile; \
	cd structureanalysis-openalea ; \
	conda-lock lock --mamba -f environment.yml -p linux-64; \
	../list_packages.sh | sort > packages.txt; \
	sudo docker build -t ${DOCKER_USER}/structureanalysis-openalea:latest . ; \
	cd .. ; \
	sudo docker run --rm -w ${TESTDIR} -v ${PWD}:${TESTDIR} ${DOCKER_USER}/structureanalysis-openalea:latest ./run_tests.sh structureanalysis-openalea
	rm ./Dockerfile
