FROM ubuntu:24.04

# Add handy metadata
LABEL \
    org.opencontainers.image.vendor="Universidad de Alcalá (UAH)"    \
    org.opencontainers.image.source="https://github.com/NetMgmt/gar" \
    org.opencontainers.image.title="gsnmp"                           \
    org.opencontainers.image.description="SNMP-enabled images"       \
    org.opencontainers.image.authors="Pablo Collado Soto"

# Make Ubuntu pull manpages
RUN sed -i 's:^path-exclude=/usr/share/man:#path-exclude=/usr/share/man:' /etc/dpkg/dpkg.cfg.d/excludes

# Install manpage goodies
RUN apt update && apt -y install man

# Trump the nasty default script impersonating man(1)
RUN mv /usr/bin/man.REAL /usr/bin/man

# Install other goodies:
#       less(1): the default more(1) is quite a pain...
#       lsof(1): an easy way to check open sockets (i.e. FDs)
#   iproute2(8): ifconfig has been deprecated for some time now...
#       ping(8): to ease checking connectivity
#        vim(1): a sane (:P) text editor
RUN apt install -y \
    less \
    lsof \
    iproute2 \
    iputils-ping \
    vim

# Install the necessary net-snmp goodies (MIBs should be already
# downloaded, but it doesn't hurt to do it again...). We'll install
# the necessary stuff for both the agent and the manager so as not
# to duplicate maintenance efforts...
RUN apt install -y snmp snmp-mibs-downloader snmpd libsnmp-dev && download-mibs

# Clean up the apt(8) cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy over necessary (and potentially conflictive) MIBs
COPY MIBs/* /usr/share/snmp/mibs

# Overwrite the flawed SNMPv2-PDU
RUN mv /usr/share/snmp/mibs/SNMPv2-PDU /usr/share/snmp/mibs/ietf/SNMPv2-PDU

# Copy the SNMP configurations over
COPY conf/snmp.conf /etc/snmp/snmp.conf
COPY conf/snmpd.conf /etc/snmp/snmpd.conf

# Setup a non-root user to avoid freaking people out
RUN useradd -ms /bin/bash kenobi

# Use th user's home directory by default
WORKDIR /home/kenobi

# Log in as kenobi by default
USER kenobi

# Get some RHEL flair in the prompt
RUN echo "PS1='[\u@\h \W]\$ '" >> .bashrc
