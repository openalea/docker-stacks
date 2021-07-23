# Openalea base

Contains the installation of OS dependencies (
wget
ca-certificates
sudo
locales
run-one), 
and the opengl drivers libgl1-mesa-glx.

It install a minimun conda, and create an environment with:
 - python=3.8 
 - pandas 
 - k3d 
 - jupyter 
 - nodejs 
 - pyvis

And the openalea packages: 

 - openalea.deploy 
 - openalea.mtg 
 - openalea.plantgl 

The docker can be retrieved at openalea/base
