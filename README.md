# A template for running an nginx/uvicorn container using makefile generation
## How It Works
	[Jump Here](#detail)

## Usage
	* Install docker
	* Clone repo
	* run `make`
	* open **localhost:8080**
	* have fun.

## License
	MIT License.

## detail
	### makefile
		* The makefile has 2 build steps.
			1. docker run
			1. docker build
		* step **1** is *always* ran because its target is never created. So always expect `make` to attempt to run a container.
		* the DOCKERBUILDTOUCH file is a fake target that remembers the build time.
		* when files in context folder are changed, step **2** from above is ran
		* it also checks that the directory structure exists correctly locally
		* there are some phony targets/commands that are useful use `make <command>`
			1. clean - does **2** and **3**
			1. del-cont - fully stops the container from `docker ps -a`
			1. del-img - deletes the image ( not including dangling )
			1. login - `docker exec` - terminal session into your container
			1. logs - print app logs from inside the running container
			1. inspect - print debug info about the container.


