# Network Administration - Lab 03
This repository contains all the necessary bits and pieces to work through the
first lab assignment of the Network Administration Course at Universidad de Alcalá.

We leverage [`docker`][docker] and more specifically [`docker-compose`][docker-compose]
to run everything. This means you'll need to [install][docker-installation] it on
your machine before proceeding. This setup will work across operating systems, so you
can run whatever you prefer.

Given the assignment needs, these containers run [supervisord][supervisord] as a
makeshift init system. The user should interact with the different processes
through the [`supervisorctl(1)`][supervisorctl] command. The manpage provides
a myriad information on how to start and stop services!

## Starting things up
In order to kickstart the setup simply run

    $ docker-compose up -d

This'll trigger both containers and you're ready to rock!

## Logging into the containers
You can leverage `docker exec` to do so. In this particular case we can open up
a shell in any of the two available containers with

    # Host 1
    $ docker exec -it host-1 bash

    # Host 2
    $ docker exec -it host-2 bash

    # Host 3
    $ docker exec -it host-3 bash

The shells will be ran by `root`; it you want to run as a regular user you should
explicitly specify that with the `--user kenobi` flag. For instance:

    # Open a shell on host 1 as kenobi
    $ docker exec -it --user kenobi bash

## Starting and stopping services
Instead of the usual `systemd(1)`, these containers run a python-based init system
called `supervisrod(1)`. We can interact with it through the `supervisorctl(1)`
command. For the lab assignment you'll mostly be dealing with the `rsyslog` service
we have defined. The following examples showcase the most common uses of the command,
but as always the best source of information is the command's manpage.

    # List available services
    $ docker exec -it host-1 supervisorctl status
    rsyslog                          STOPPED   Not started

    # Start a service by name
    $ docker exec -it host-1 supervisorctl start rsyslog
    rsyslog: started

    # Restart a (running) service by name
    $ docker exec -it host-1 supervisorctl restart rsyslog
    rsyslog: stopped
    rsyslog: started


Please note that `supervisorctl(1)` **must** be invoked by `root` and that no services
are configured to be automatically started.

## Checking connectivity
The deployment will be set up automatically so that both containers belong to the
same subnet. What's more, `/etc/hosts` will be configured so that one can refer
to the other container by name: it couldn't be more convenient! This basically
means that things work out of the box:

    $ docker exec -it host-1 ping -c 3 host-2
    PING host-2 (10.0.123.3) 56(84) bytes of data.
    64 bytes from host-2.l3_rsyslog_net (10.0.123.3): icmp_seq=1 ttl=64 time=1.81 ms
    64 bytes from host-2.l3_rsyslog_net (10.0.123.3): icmp_seq=2 ttl=64 time=0.149 ms
    64 bytes from host-2.l3_rsyslog_net (10.0.123.3): icmp_seq=3 ttl=64 time=0.166 ms

    --- host-2 ping statistics ---
    3 packets transmitted, 3 received, 0% packet loss, time 2021ms
    rtt min/avg/max/mdev = 0.149/0.707/1.807/0.777 ms

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

    $ docker build -t ghcr.io/pcolladosoto/gp3:latest .

where `ghcr.io/pcolladosoto/gp3:latest` is the images tag. This basically
determines where the image will be pushed to to make it readily available.

<!-- REFs -->
[docker]: https://www.docker.com/
[docker-compose]: https://docs.docker.com/compose/
[docker-installation]: https://docs.docker.com/engine/install/
[supervisord]: https://supervisord.org/
[supervisorctl]: https://supervisord.org/running.html#supervisorctl-actions
