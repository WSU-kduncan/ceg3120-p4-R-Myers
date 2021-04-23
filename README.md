# CEG 3120 - Project 4 - Robert Myers

* This project demonstrates containerizing software as a launchable package using Docker (and sort-of AWS).

## Dependencies

* [WLS2](https://docs.microsoft.com/en-us/windows/wsl/install-win10)
* [Docker](https://www.docker.com/)
* [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html)
* [Dockerhub](https://www.docker.com/products/docker-hub)
* [Docker Cheatsheet (for reference)](https://dockerlabs.collabnix.com/docker/cheatsheet/)

## 1) Building the Container
* Once Docker is installed on your machine, you will want to select an image from Dockerhub (linked above) on which to build your container. 
  * For this project we are using [Apache (httpd)](https://hub.docker.com/_/httpd).
  * This image can be pulled right now for future use (```docker pull httpd```), or you can specify it when building the container and it will download it then for you to keep for future use.
* Docker will provide you, without explanation, with a command for you to copy-paste that will build a default container for you that you. This step can be skipped but it is a way of testing its success.
* To build your first container: 
  *  use the ```docker run``` command and include ```-dit``` which will run the container in the background (detached mode), among some other necessary specifics.
  *  Name the container with ```--name [containerName]```
  *  Bind the container to a port on the local machine with ```-p [containerPort]:[machinePort]```
  *  Copy files into the container using ```-v "$PWD/[fileDir]":[containerDir]```
  *  Specify the image to use for this container with ```[imageName]:[imageVersion]```
  *  If you did not already pull the image you specified, and the command is properly typed, it will now download that image and you will need to wait.
* This process can be simplified by creating a Dockerfile--named exactly as such, much like a Makefile--and specifying these details within that file first.
  * Within the Dockerfile you can specify the image and version to use using ```FROM```, and also the copying of files into the container using ```COPY```.
  * Then all you need to do is use a ```docker build -d``` command, along with a name/version you choose for the container.
  * Once that container has been built using the Dockerfile, it can be run with ```docker run``` just as before, but all you need to include now is ```-d```, your port bindings, and the name of the container/version you wish to run.
* Using the Apache server image, and with an index.html file included in the container in its correct location, you should be able to direct your browser to ```127.0.0.1:[containerPort]``` and see your index file.

## 2) AWS CLI
