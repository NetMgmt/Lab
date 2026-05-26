# GP4 — Gestión de configuración mediante Ansible
## Escenario Docker para la práctica de laboratorio

---

## Topología

```
manager (10.0.125.2)
   │
   ├── SSH/Ansible ──► host1 (10.0.125.3)
   └── SSH/Ansible ──► host2 (10.0.125.4)
```

| Contenedor | IP           | Rol                        |
|------------|--------------|----------------------------|
| manager    | 10.0.125.2   | Nodo de control Ansible    |
| host1      | 10.0.125.3   | Nodo gestionado (agente)   |
| host2      | 10.0.125.4   | Nodo gestionado (agente)   |

---

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
|          `manager` | 10.0.123.4/24         |


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

    # Manager
    $ docker exec -it -u kenobi manager bash

## Checking connectivity
The deployment will be set up automatically so that both containers belong to the
same subnet. What's more, `/etc/hosts` will be configured so that one can refer
to the other container by name: it couldn't be more convenient! This basically
means that things work out of the box:

    $ docker exec -it manager ping -c 3 host-1
    PING host-1 (10.0.123.2) 56(84) bytes of data.
    64 bytes from host-1.l4_gar-net (10.0.123.2): icmp_seq=1 ttl=64 time=1.79 ms
    64 bytes from host-1.l4_gar-net (10.0.123.2): icmp_seq=2 ttl=64 time=0.113 ms
    64 bytes from host-1.l4_gar-net (10.0.123.2): icmp_seq=3 ttl=64 time=0.385 ms

    --- host-1 ping statistics ---
    3 packets transmitted, 3 received, 0% packet loss, time 2046ms
    rtt min/avg/max/mdev = 0.113/0.761/1.786/0.733 ms

## Checking Ansible's set up correctly
We can simply leverage the `ansible.builtin.ping` module:

    $ docker exec -it -u kenobi manager ansible servers -m ansible.builtin.ping
    10.0.123.3 | SUCCESS => {
        "ansible_facts": {
            "discovered_interpreter_python": "/usr/bin/python3.14"
        },
        "changed": false,
        "ping": "pong"
    }
    10.0.123.2 | SUCCESS => {
        "ansible_facts": {
            "discovered_interpreter_python": "/usr/bin/python3.14"
        },
        "changed": false,
        "ping": "pong"
    }

We can clearly verify both hosts are reachable from the manager. With that we can
get to work!

## Tearing things down
When you're done, simply clean everything up with

    $ docker-compose down

That's it!

## A bit more info...
The setup is orchestrated by the contents of `compose.yml`. This file
simply runs the image containing the necessary dependencies. We have
crafted the image based on the accompanying `Dockerfile`. This setup
leverages two different images which can be built with

    $ docker build --platform linux/amd64,linux/arm64 -t ghcr.io/netmgmt/gp4-manager:latest -f manager.dockerfile .
    $ docker build --platform linux/amd64,linux/arm64 -t    ghcr.io/netmgmt/gp4-host:latest -f    host.dockerfile .

where `ghcr.io/netmgmt/gp4-{manager,host}:latest` are the images tags. This basically
determines where the image will be pushed to to make it readily available.

<!-- REFs -->
[docker]: https://www.docker.com/
[docker-compose]: https://docs.docker.com/compose/
[docker-installation]: https://docs.docker.com/engine/install/
[supervisord]: https://supervisord.org/
[supervisorctl]: https://supervisord.org/running.html#supervisorctl-actions
