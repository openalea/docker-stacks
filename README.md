# Openalea Docker Images

_This is an ongoing project. This README is subject to modification, as well as the whole behaviour of the package._

-------------

This projects aims at publishing ready to use images of [OpenAlea](https://openalea.readthedocs.io/en/latest/) stacks in a reproducible computing environment. These images are built on top of the Ubuntu operating system using [conda environments](https://conda.io/projects/conda). It is heavily inspeired by existing [openalea docker stacks](https://github.com/openalea/docker-stacks) and [pangeo-docker-images](https://github.com/pangeo-data/pangeo-docker-images) projects.

Images are meant to be hosted on [DockerHub](https://hub.docker.com/u/openalea). 

So far, here is a list of images created. You can easily add your creation of images and propose to include it in this project (cf. steps bellow):

| Image                         | Description                                   |  
|-------------------------------|-----------------------------------------------|
| base-openalea                 | Foundational Dockerfile for builds. Not intended for use           | 
| [openalea-notebook](notebook-openalea/packages.txt)          | Functional image with basic Openalea packages + advanced widgets for interactive visualization using [lpy](https://lpy.readthedocs.io/en/latest/) and [PlanGL](https://plantgl-cpl.readthedocs.io/en/latest/)  | 
| [strawberry-openalea](strawberry-openalea/packages.txt) | __openalea-notebook__ + [strawberry](https://github.com/openalea/strawberry) package and associated interactive visualization tools          | 
| [hydroroot-openalea](hydroroot-openalea/packages.txt) | __openalea-notebook__ + [hydroroot](https://github.com/openalea/hydroroot) package and associated interactive visualization tools          | 
| [fullstack-openalea](fullstack-openalea/packages.txt) | All the packages release en 05-2022 on the [openalea3 anaconda channel](https://anaconda.org/openalea3/repo) + advanced widgets for interactive visualization used in __openalea-widgets-notebook__ |

*Click on the image name in the table above for a current list of installed packages and versions*

### How to launch Jupyterlab locally with one of these images
At launching one image, a __conda__ environments named _openalea_ is automaticaly loaded with all packages already installed.
You can directly launch a jupyter interface with:
```
docker run -it --rm -p 8888:8888 openalea/notebook-openalea:latest jupyter lab --ip 0.0.0.0
```
or do it in two steps, 1) launching a bash session inside the container, 2) lauch a jupyter lab:
```
docker run -it --rm -p 8888:8888 openalea/notebook-openalea:latest /bin/bash

jupyter lab --ip='*' --port=8888 --no-browser
```
To access files from your local hard drive from within the Docker Jupyterlab, you need to use a Docker [volume mount](https://docs.docker.com/storage/volumes/). The following command will mount your home directory in the docker container and launch the Jupyterlab from there.

```
docker run -it --rm --volume $HOME:$HOME -p 8888:8888 openalea/notebook-openalea:latest jupyter lab --ip 0.0.0.0 $HOME
```

### How to build images
#### **Localy**

To build images localy, you'll need Conda installed.
```
# create a fork of this repo and clone it locally
git clone https://cirad.gitlab/openalea/openalea-docker-images
cd openalea-docker-images
# Install conda-lock
conda install conda-lock
```

Edit any `environment.yml` to change packages installed using `conda`/`mamba`, or `requirements.txt` to change the list of packages installed using `pip`, or even `sources.txt` for packages that need to be installed from sources cloning the `.git` repository and using `setup.py` ! 

Then `make notebook-widgets-openalea` (for example) allows to build and test the image. See the Makefile for specific commands that are run. 

To add your own image:
1. create a new directory at the base of the project
```
mkdir fancy-image-openalea
cd fancy-image-openalea
```
2. add the relevant `apt.txt`, `environment.yml`, `requirements.txt`, `sources.txt` to install linux utilities, tools and python libraries via conda, python libraries via pip, python libraries via git repositories, respectively. Use can use as templates the files available in `strawberry-openalea` for example.
```
vi apt.txt
vi environment.yml
vi requirements.txt
vi sources.txt
``` 
3. Create a Dockerfile
Create your own Dockerfile. The mandatory line is the first one
```
FROM openalea/base-openalea:latest
```
This will install all the libraries and packages provided in the step before. If additional operations are necessary (like copying example files or data), this has to be done here.

4. Modify the Makefile
Simply add you new rule to compile the new image following the rule used for existing images.

#### **Continous integration**
> :warning: **Deprecated**. Only valid for Gitlab-CI. Need to update for github-actions
Continous integration has been implemented for _Gitlab_, _cf._ the [original gitlab page of the project](https://gitlab.cirad.fr/openalea/openalea-docker-images/-/blob/master/.gitlab-ci.yml). Every time you push a commit on this project, it will first build and upload to dockerhub the `base-image`, then build and upload all the other images on top of it, and finaly test all the images. 
You need to register [Gitlab-CI-CD variables](https://docs.gitlab.com/ee/ci/variables/) to login to your dockerhub account (`CI_REGISTRY_USER` and `CI_REGISTRY_PASSWORD`).

If you want to add your image, when you're done creating the folder describing your new image (cf. steps 1 to 3 in the previous section), you simply need to add your image name in the `parallel:matrix:IMAGE_NAME` section of `.gitlab-ci.yml` file, both for building stage et testing stage.

### Launching OpenAlea and Visualea in Docker 

For the python2 image : 

You need a lot of options in the `docker run` since the container run a X server (they are indicated in the README of the file).
Additionally, there is no need to open the ports since it just open an app.

```
pip install docker
docker pull openalea/python2
docker run -it --env QT_X11_NO_MITSHM=1 -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix --volume=$PWD:/home/User001:rw openalea/python2
```

For Mac users, preliminary steps are necessary (cf. https://cntnr.io/running-guis-with-docker-on-mac-os-x-a14df6a76efc)

```
# retrive IP address from host OS
ipAdress=`ifconfig | grep inet | grep broadcast | awk '{print $2}' | tail -1`

# deal with the socat
socat TCP-LISTEN:6000,reuseaddr,fork UNIX-CLIENT:\"$DISPLAY\" &

docker run -it --rm --env="DISPLAY=${ipAdress}:0" --volume=$PWD:/home/User001:rw openalea/python2:latest

# Kill socat
lsof -n -i | grep 6000 | grep IPv6 | awk '{print $2}' | xargs kill -9
```


### Contribute

If you created an image of any Openalea package or package list, you are welcome to submit a pull request containing a summary of all depedancies, the version of the build, and wich packages are concerned. We will also need a image on Docker Hub to test it.
