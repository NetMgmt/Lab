# Network Administration - Lab 03
This repository contains all the necessary bits and pieces to work through the
first lab assignment of the Network Administration Course at Universidad de Alcalá.

We leverage [`docker`][docker] and more specifically [`docker-compose`][docker-compose]
to run everything. This means you'll need to [install][docker-installation] it on
your machine before proceeding. This setup will work across operating systems, so you
can run whatever you prefer.

## Network scenario
| **Container Name** | **IPv4 CIDR Address** |
| -----------------: | :-------------------: |
|           `host-1` | 10.0.123.2/24         |
|           `host-2` | 10.0.123.3/24         |
|           `host-3` | 10.0.123.4/24         |

## Important logs files
| **Service Name**   |   **Logfile path**   |
| -----------------: | :------------------: |
|         `rsyslogd` | `/tmp/rsyslogd.log`  |

This lab revolves around the syslog facility implemented through `rsyslogd(8)`. The
most interesting file is `/var/log/syslog` where `rsyslogd(8)` outputs by default.

## Starting things up
In order to kickstart the setup simply run

    $ docker-compose up -d

This'll trigger both containers and you're ready to rock!

## Logging into the containers
You can leverage `docker exec` to do so. In this particular case we can open up
a shell in any of the two available containers with

    # Host 1
    $ docker exec -it -u kenobi host-1 bash

    # Host 2
    $ docker exec -it -u kenobi host-2 bash

    # Host 3
    $ docker exec -it -u kenobi host-3 bash

## Starting services
These containers leverage supervisord as the init system. This simply means that services
are managed through the `supervisorctl(1)` command. For this particular scenario you can
start the rsyslog daemon, `rsyslogd(8)` with:

    # Check the available services and their status
    $ docker exec -it -u kenobi host-1 supervisorctl status

    # Start the rsyslogd service
    $ docker exec -it -u kenobi host-1 supervisorctl start rsyslogd

## Checking connectivity
The deployment will be set up automatically so that both containers belong to the
same subnet. What's more, `/etc/hosts` will be configured so that one can refer
to the other container by name: it couldn't be more convenient! This basically
means that things work out of the box:

    $ docker exec -it host-1 ping -c 3 host-2
    PING host-2 (10.0.123.3) 56(84) bytes of data.
    64 bytes from host-2.l3_gar-net (10.0.123.3): icmp_seq=1 ttl=64 time=0.096 ms
    64 bytes from host-2.l3_gar-net (10.0.123.3): icmp_seq=2 ttl=64 time=0.196 ms
    64 bytes from host-2.l3_gar-net (10.0.123.3): icmp_seq=3 ttl=64 time=0.187 ms

    --- host-2 ping statistics ---
    3 packets transmitted, 3 received, 0% packet loss, time 2075ms
    rtt min/avg/max/mdev = 0.096/0.159/0.196/0.045 ms

## Tearing things down
When you're done, simply clean everything up with

    $ docker-compose down

That's it!

## A bit more info...
The setup is orchestrated by the contents of `compose.yml`. This file
simply runs the image containing the necessary dependencies. We have
crafted the image based on the accompanying `Dockerfile`.

Building the image is a matter of running

    $ docker build -t ghcr.io/netmgmt/gp3:latest .

where `ghcr.io/netmgmt/gp3:latest` is the images tag. This basically
determines where the image will be pushed to to make it readily available.

<!-- REFs -->
[docker]: https://www.docker.com/
[docker-compose]: https://docs.docker.com/compose/
[docker-installation]: https://docs.docker.com/engine/install/
[supervisord]: https://supervisord.org/
[supervisorctl]: https://supervisord.org/running.html#supervisorctl-actions
