# docker-stacks
Docker-Stacks is where you can find ready-to-run Docker images containing Openalea applications.
All those images are in [Docker Hub](https://hub.docker.com/)

To use any of those images, you will need to : 
- **Install docker** with ```sudo apt-get install docker``` or ```pip install docker```
- **Import the image** on your computer with either ```docker pull <user>/<docker>``` if you want to pull it from an URL or ```docker build -t <docker_name> <path>``` if you want to create it from a Dockerfile in your PC.
- **Run the docker** using ```docker run -it -p 8888:8888 <docker_name>```

Note that the `docker run` command may get more complicated depending of what the docker needs to run.

### Example with the python2 image and the Strawberry image

For the python2 image : 

You need a lot of options in the `docker run` since the container run a X server (they are indicated in the README of the file).
Additionally, there is no need to open the ports since it just open an app.

```
pip install docker
docker pull openalea/python2
docker run -it --env QT_X11_NO_MITSHM=1 -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix --volume=$PWD:/home/User001:rw openalea/python2
```

For Mac users, preliminary steps are necessary (cf. )

```
# retrive IP address from host OS
ipAdress=`ifconfig | grep inet | grep broadcast | awk '{print $2}' | tail -1`

# deal with the socat
socat TCP-LISTEN:6000,reuseaddr,fork UNIX-CLIENT:\"$DISPLAY\" &

docker run -it --rm --env="DISPLAY=${ipAdress}:0" --volume=$PWD:/home/User001:rw openalea/python2:latest

# Kill socat
lsof -n -i | grep 6000 | grep IPv6 | awk '{print $2}' | xargs kill -9
```

As for Strawberry image : 

```
WIP
```

### Contribute

If you created an image of any Openalea package or package list, you are welcome to submit a pull request containing a summary of all depedancies, the version of the build, and wich packages are concerned. We will also need a image on Docker Hub to test it.
