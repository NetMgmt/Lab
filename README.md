# Network Administration - Lab 01
This repository contains all the necessary bits and pieces to work through the
first lab assignment of the Network Administration Course at Universidad de Alcalá.

We leverage [`docker`][docker] and more specifically [`docker-compose`][docker-compose]
to run everything. This means you'll need to [install][docker-installation] it on
your machine before proceeding. This setup will work across operating systems, so you
can run whatever you prefer.

## Starting things up
In order to kickstart the setup simply run

    $ docker-compose up -d

This'll trigger both containers and you're ready to rock!

## Logging into the containers
You can leverage `docker exec` to do so. In this particular case we can open up
a shell in any of the two available containers with

    # Manager
    $ docker exec -it manager bash

    # Agent
    $ docker exec -it agent bash

That's all really!

## Tearing things down
When you're done, simply clean everything up with

    $ docker-compose down

That's it!

## A bit more info...
The setup is orchestrated by the contents of `compose.yml`. This file
simply runs the image containing the necessary dependencies. We have
crafted the image based on the accompanying `Dockerfile`. The build
process leverages both the 'ready-made' SNMP configuration files and
the extra MIBs that aren't bundled with Ubuntu due to licensing
issues.

Building the image is a matter of running

    $ docker build -t ghcr.io/pcolladosoto/gp1:latest .

where `ghcr.io/pcolladosoto/gp1:latest` is the images tag. This basically
determines where the image will be pushed to to make it readily available.

<!-- REFs -->
[docker]: https://www.docker.com/
[docker-compose]: https://docs.docker.com/compose/
[docker-installation]: https://docs.docker.com/engine/install/
