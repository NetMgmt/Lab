# Network Administration Labs
This repository contains the files needed to set up the lab assignments for the [Net Management][net-mgmt]
and [Net Management and Security][net-mgmt-sec] courses at [Universidad de Alcalá][uah] (UAH).

The different scenarios can be found under the `l*` directories, with all the contents necessary for a given
assignment located there. All the scenarios are based on Docker in the sense that they are provided through
a Docker Compose file. When starting the scenario up, a number of containers serving as the hosts will be
started: your work involves opening shells on each of them and capturing traffic, modifying configurations
and the like. Each directory contains further instructions on how to leverage it.

## What do you need?
You just need to install [Docker][docker]. Nowadays they are really pushing the Docker Desktop approach which
is (you guessed it) another bloated probably web-based program. If you're feeling adventurous you can take
a look at [Podman][podman] as an alternative, but know it is **not supported**: you're on your own.

One of the key advantages of leveraging Docker is that we can eschew heavy and less-compatible hypervisors
underpinning technologies like [Vagrant][vagrant]. Note we distribute images targetting both `x86_64` and
`aarch64` architectures, so images should be able to run as-is on any machine.

## Getting content out of a container
Even though you can usually mount a [volume][docker-volume], it'll usually be easier to just leverage the
[`docker cp`][docker-cp] command to pull individual files if necessary. Be sure to read the documentation,
but if you want to pull file `/etc/foo.conf` from container `manager` you should be able to run

  $ docker cp manager:/etc/foo.conf foo.conf

and the file should now be locally available as `foo.conf`. When providing content for reports be sure to
include text instead of PNGs and relate image formats: that makes PDFs leaner and searchable!

## How are images prepared?
Images are all built from a base image as explained below. These images leverage [supervisord][supervisord]
as an init system: more on that below too.

These images contain 3 users:

- User `root`'s the default one you'll be running as if executing `docker exec ...`. Even though things
  will work, we advise against doing stuff as root given permissions and such will get jumbled sooner
  rather than later.

- User `supervisord`'s the one running our init system. You'll rarely (if ever) need to run as this user.

- User `kenobi` as in everyone's favourite Jedi, is the one you should usually run as. Just pass the
  `-u kenobi` flag when invoking `docker exec ...` and you should be good to go. This is all explained
  on each scenario so don't worry too much about it.

Be sure to take a look at the different `Dockerfiles` scattered around the repo to learn a bit more about
the plumbing underlying these images. To get a nice list be sure to run:

    $ find . -name Dockerfile

## Building Docker images
Users of the repository needn't be concerned with building the images themselves. However, maintainers do
need to look into that... On large(-ish) projects image creation's usually automated with `make(1)` or
similar tools. Given we expect these images to be rather static (i.e. maybe changing on a yearly basis)
we'd rather build them manually.

Given the [Ubuntu image][ubuntu-img] is rather bare-bones we'll be needing to add some extras on top such
as a text editor. Given all images will be needing this we've decided to create a `base` image others
build on top of. The `Dockerile` defining this image's contents can be found [here](./Dockerfile). In
order to build it run:

    $ docker build --platform linux/amd64,linux/arm64 -t ghcr.io/netmgmt/base:latest .

The above will build the image and tag it with `ghcr.io/netmgmt/base:latest`. This will allow us
to push the image directly to [GitHub's Container Registry][ghcr]; be sure to read the linked site
for information on how to set up authentication and the like. Onece built, the image can be pushed
with:

    $ docker push ghcr.io/netmgmt/base:latest

## A note on supervisord
Linux systems traditionally leverage [systemd][systemd] to manage services. In our constrained use case
we'll instead make use of [supervisord][supervisord], a Python-based tool suitable for containerised
environments.

What does this mean? Basically that instead of `systemctl(1)` you'll be using `supervisorctl(1)`. Be sure
to check a lab's README.md for more information on that particular scenario.

## Questions? Something broken?
If you find anything that's not working quite right be sure to open an [issue][issue]: we'll try to get
back to it ASAP!

<!-- REFs -->
[net-mgmt]: https://nuevauah.uah.es/es/estudios/estudios-oficiales/grados/asignatura/Gestion-y-Administracion-de-Redes-380010/
[net-mgmt-sec]: https://www.uah.es/es/estudios/estudios-oficiales/grados/asignatura/Gestion-de-Redes-y-Seguridad-591004/
[uah]: https://uah.es/es/
[docker]: https://docs.docker.com/desktop/
[vagrant]: https://developer.hashicorp.com/vagrant
[podman]: https://podman.io/
[systemd]: https://systemd.io/
[supervisord]: https://supervisord.org/
[issues]: https://github.com/NetMgmt/gar/issues
[ubuntu-img]: https://hub.docker.com/_/ubuntu
[ghcr]: https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry
[docker-volume]: https://docs.docker.com/engine/storage/volumes/
[docker-cp]: https://docs.docker.com/reference/cli/docker/container/cp/
