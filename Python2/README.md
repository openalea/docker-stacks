# Docker Python2

Dockerfile to create a Python2 with OpenAlea, Vplants and Alinea.
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
