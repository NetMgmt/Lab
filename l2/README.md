# Network Administration - Lab 02
This repository contains all the necessary bits and pieces to work through the
second lab assignment of the Network Administration Course at Universidad de Alcalá.

We leverage [`docker`][docker] and more specifically [`docker-compose`][docker-compose]
to run everything. This means you'll need to [install][docker-installation] it on
your machine before proceeding. This setup will work across operating systems, so you
can run whatever you prefer.

## Network scenario
| **Container Name** | **IPv4 CIDR Address** |
| -----------------: | :-------------------: |
|          `manager` | 10.0.123.2/24         |
|            `agent` | 10.0.123.3/24         |

## Important logs files
| **Service Name**   |   **Logfile path**   |
| -----------------: | :------------------: |
|            `snmpd` | `/tmp/snmptrapd.log` |
|        `snmptrapd` | `/tmp/snmpd.log`     |

Be sure to leverage `cat(1)` and `tail(1)` to have a look!

## Starting things up
In order to kickstart the setup simply run

    $ docker-compose up -d

This'll trigger both containers and you're ready to rock!

## Logging into the containers
You can leverage `docker exec` to do so. In this particular case we can open up
a shell in any of the two available containers with

    # Manager
    $ docker exec -it -u kenobi manager bash

    # Agent
    $ docker exec -it -u kenobi agent bash

That's all really!

## Starting services
These containers leverage supervisord as the init system. This simply means that services
are managed through the `supervisorctl(1)` command. For this particular scenario you can
start the SNMP daemon, `snmpd(8)` with:

    # Check the available services and their status
    $ docker exec -it -u kenobi agent supervisorctl status

    # Start the snmpd service
    $ docker exec -it -u kenobi agent supervisorctl start snmpd

### Checking connectivity
The deployment will be set up automatically so that both containers belong to the
same subnet. What's more, `/etc/hosts` will be configured so that one can refer
to the other container by name: it couldn't be more convenient! This basically
means that things work out of the box:

    $ docker exec -it manager ping -c 3 agent
    PING agent (10.0.123.2) 56(84) bytes of data.
    64 bytes from agent.l1_gar-net (10.0.123.2): icmp_seq=1 ttl=64 time=0.219 ms
    64 bytes from agent.l1_gar-net (10.0.123.2): icmp_seq=2 ttl=64 time=0.126 ms
    64 bytes from agent.l1_gar-net (10.0.123.2): icmp_seq=3 ttl=64 time=0.204 ms

    --- agent ping statistics ---
    3 packets transmitted, 3 received, 0% packet loss, time 2060ms
    rtt min/avg/max/mdev = 0.126/0.183/0.219/0.040 ms

Using a more suitable example for the matter at hand:

    $ docker exec -it manager snmpget -c public -v 1 agent system.sysName.0
    SNMPv2-MIB::sysName.0 = STRING: agent

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
issues. We also include several pre-cooked scripts to make sending
traps a bit easier. What's more, there's some fiddling with permissions
to make `supervisord` (i.e. the user running all the processes) capable
of reading files under `/home/kenobi`.

Building the image is a matter of running

    $ docker build -t ghcr.io/netmgmt/gp2:latest .

where `ghcr.io/netmgmt/gp2:latest` is the images tag. This basically
determines where the image will be pushed to to make it readily available.

<!-- REFs -->
[docker]: https://www.docker.com/
[docker-compose]: https://docs.docker.com/compose/
[docker-installation]: https://docs.docker.com/engine/install/
