# Introduction

Dockerfile to build a Redmine container image.

## Version

Current Version: **2.5.2-2**

# Reporting Issues

Docker is a relatively new project and is active being developed and tested by a thriving community of developers and testers and every release of docker features many enhancements and bugfixes.

Given the nature of the development and release cycle it is very important that you have the latest version of docker installed because any issue that you encounter might have already been fixed with a newer docker release.

For ubuntu users I suggest [installing docker](https://docs.docker.com/installation/ubuntulinux/) using docker's own package repository since the version of docker packaged in the ubuntu repositories are a little dated.

Here is the shortform of the installation of an updated version of docker on ubuntu.

```bash
sudo apt-get purge docker.io
curl -s https://get.docker.io/ubuntu/ | sudo sh
sudo apt-get update
sudo apt-get install lxc-docker
```

Fedora and RHEL/CentOS users should try disabling selinux with `setenforce 0` and check if resolves the issue. If it does than there is not much that I can help you with. You can either stick with selinux disabled (not recommended by redhat) or switch to using ubuntu.

If using the latest docker version and/or disabling selinux does not fix the issue then please file a issue request on the [issues](https://github.com/dockerimages/docker-redmine/issues) page.

In your issue report please make sure you provide the following information:

- The host ditribution and release version.
- Output of the `docker version` command
- Output of the `docker info` command
- The `docker run` command you used to run the image (mask out the sensitive bits).

# Installation

Pull the image from the docker index. This is the recommended method of installation as it is easier to update image in the future. These builds are performed by the Trusted Build service.

```bash
docker pull dockerimages/redmine:latest
```

Since version `2.4.2`, the image builds are being tagged. You can now pull a particular version of redmine by specifying the version number. For example,

```bash
docker pull dockerimages/redmine:2.5.2-2
```

Alternately you can build the image yourself.

```bash
git clone https://github.com/dockerimages/docker-redmine.git
cd docker-redmine
docker build --tag="$USER/redmine" .
```

# Quick Start

Run the redmine image with the name "redmine".

```bash
docker run --name=redmine -it --rm -p 10080:80 \
dockerimages/redmine:2.5.2-2
```

**NOTE**: Please allow a minute or two for the Redmine application to start.

Point your browser to `http://localhost:10080` and login using the default username and password:

* username: **admin**
* password: **admin**

You should now have the Redmine application up and ready for testing. If you want to use this image in production the please read on.



# Shell Access

For debugging and maintenance purposes you may want access the container shell. Since the container does not include a SSH server, you can use the [nsenter](http://man7.org/linux/man-pages/man1/nsenter.1.html) linux tool (part of the util-linux package) to access the container shell.

Some linux distros (e.g. ubuntu) use older versions of the util-linux which do not include the `nsenter` tool. To get around this @jpetazzo has created a nice docker image that allows you to install the `nsenter` utility and a helper script named `docker-enter` on these distros.

To install the nsenter tool on your host execute the following command.

```bash
docker run --rm -v /usr/local/bin:/target dockerimages/nsenter
```

Now you can access the container shell using the command

```bash
sudo docker-enter redmine
```

For more information refer https://github.com/dockerimages/nsenter

Another tool named `nsinit` can also be used for the same purpose. Please refer https://jpetazzo.github.io/2014/03/23/lxc-attach-nsinit-nsenter-docker-0-9/ for more information.

# Upgrading

To upgrade to newer redmine releases, simply follow this 4 step upgrade procedure.

**Step 1**: Update the docker image.

```bash
docker pull dockerimages/redmine:2.5.2-2
```

**Step 2**: Stop and remove the currently running image

```bash
docker stop redmine
docker rm redmine
```

**Step 3**: Backup the database in case something goes wrong.

```bash
mysqldump -h <mysql-server-ip> -uredmine -p --add-drop-table redmine_production > redmine.sql
```

**Step 4**: Start the image

```bash
docker run --name=redmine -d [OPTIONS] dockerimages/redmine:2.5.2-2
```

## Rake Tasks

The `app:rake` command allows you to run redmine rake tasks. To run a rake task simply specify the task to be executed to the `app:rake` command. For example, if you want to send a test email to the admin user.

```bash
docker run --name=redmine -d [OPTIONS] \
  dockerimages/redmine:2.5.2-2 app:rake redmine:email:test[admin]
```

Similarly, to remove uploaded files left unattached

```bash
docker run --name=gitlab -d [OPTIONS] \
  dockerimages/gitlab:7.2.1 app:rake redmine:attachments:prune
```

For a complete list of available rake tasks please refer www.redmine.org/projects/redmine/wiki/RedmineRake.

## References
  * http://www.redmine.org/
  * http://www.redmine.org/projects/redmine/wiki/Guide
  * http://www.redmine.org/projects/redmine/wiki/RedmineInstall
