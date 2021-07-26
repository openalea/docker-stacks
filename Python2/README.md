# Docker Python2

Dockerfile to create a Python2 with OpenAlea, Vplants and Alinea working with Ubuntu 14.04.

It installs a minimualistic Unbuntu 14.04 and : 
- Python=2.7
- python-matplotlib
- software-properties-common 
- xserver-xorg-input-all
- python-qt4
- python-opencv
- subversion
- git

And OpenAlea packages from apt repositories : 
- openalea
- vplants
- alinea

Type ```visualea``` in the container to launch it.



## Protocol to launch the Docker in your machine :

### From Docker Hub : 

```
docker pull openalea/python2
docker run -it --env QT_X11_NO_MITSHM=1 -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix openalea/python2
```

### From a file in your computer :

```
docker built -t python2 . 
docker run -it --env QT_X11_NO_MITSHM=1 -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix python2
```

If you get an Xserver error, the command ```xhost +``` may resolve it.
