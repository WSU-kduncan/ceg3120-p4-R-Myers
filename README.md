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
  * Within the Dockerfile you can specify the image and version to use with ```FROM```, run installation commands within the container using ```RUN```, and also copy files into the container using ```COPY```.
  * Then all you need to do is use a ```docker build -d``` command, along with a name/version you choose for the container.
  * Once that container has been built using the Dockerfile, it can be run with ```docker run``` just as before, but all you need to include now is ```-d```, your port bindings, and the name of the container/version you wish to run.
* Using the Apache server image, and with an index.html file included in the container in its correct location, you should be able to direct your browser to ```127.0.0.1:[containerPort]``` and see your index file.

## 2) AWS CLI
* To make use of the AWS CLI commands, you'll first need to install it. Using the Link for the CLI above, and selecting Linux as our installation system, we will copy three commands to our WSL2 CLI:
  * ```curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"```
    * This downloads to correct file and saves it at ```awsclivs.zip```
  * ```unzip awscliv2.zip```
    * This unzips the compressed file. In my case I also had to install "unzip": ```sudo apt installl unzip```
  * ```sudo ./aws/install```  
    * This runs the installation command that was unzipped.
  * If successful, there will be a new ```.aws``` directory in your home directory, and the AWS library should exist within your /usr/lib/ directory.
* In order to make use of the CLI, it then needs to be configured with the credentials of an AWS IAM user.
  * Type ```aws configure```
  * Enter the AWS access key provided to you.
  * Enter the AWS Secret Access Key provided to you.
  * Specify to correct region and output file format.
  * This will create two new files within the ```.aws``` directory called ```config``` and ```credentials``` with the associated values within.
    * You can also manually create these files quite easily, just be sure to follow formatting conventions.
* With these credentials connecting you to an IAM user with the proper permissions, you can create an ECR using the commmand: 
  * ```aws ecr create-repository --repository-name [repoName] --region [region]``` 
    *  **(Due to unforeseen circumstances, this portion of the project has been deprecated in favor of creating a Dockerhub repo via the Dockerhub site, which will be documented below.)**

## 3) Dockerhub
* Creating a Dockerhub repo is as straightforward as creating an account, choosing to use the free version, and clicking "Create Repository".
* From here, we need to accomplish a few things:
  1. With your new Dockerhub account login credentials, navigate to you Github repo and add them to your Secrets as ```DOCKER_USERNAME``` and ```DOCKER_PASSWORD```.
  2. We need a workflow that will publish a Docker image from Github to Dockerhub.
     * The YAML template found [here](https://docs.github.com/en/actions/guides/publishing-docker-images#publishing-images-to-docker-hub) will work for us.
       * This file needs to be configured. Set the ```DOCKER_HUB_REPO``` to be the [username]/[repoName] of your Dockerhub repo.
     * Push this file to your Github repo within the ```.github\workflows\``` path.
  3. With the workflow in its correct path, it should be listed under your Github Actions. This workflow is set to run when you publish a release. 
  4. Test the workflow by publishing a release. Click releases on the right, draft a new release with a tag version, and click publish. You can see the progress of your workflow within Github Actions. If it succeeds, you've done it! Also check your Dockerhub repo for the image!
     * If it failed, check the workflow file to ensure you've correctly referenced your credentials that exist within your Github Secrets.
     * If those all match, you may be able to see where the workflow went wrong by clicking the failed action in Github Actions.
* You can then test your entire setup by running a ```docker pull [dockerhubRepo]:[tag]``` which will pull your image from your Dockerhub repo, and then running it with a ```docker run -d -p [containerPort]:[machinePort] [imageName]```. Then simply navigate your browser once again to ```127.0.0.1:[containerPort]``` and see if your index.html file pops up!
