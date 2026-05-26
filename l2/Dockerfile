FROM ghcr.io/netmgmt/base:latest

# Add handy metadata
LABEL \
    org.opencontainers.image.title="Lab 02"                    \
    org.opencontainers.image.description="SNMP-enabled images"

# Install the necessary net-snmp goodies (MIBs should be already
# downloaded, but it doesn't hurt to do it again...). We'll install
# the necessary stuff for both the agent and the manager so as not
# to duplicate maintenance efforts...
RUN apt update && apt install -y snmp snmp-mibs-downloader snmpd snmptrapd libsnmp-dev && download-mibs

# Clean up the apt(8) cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy over necessary (and potentially conflictive) MIBs. Make sure user kenobi
# (belonging to group kenobi)
# can edit the files so that people don't go mad with the lack of sudo(8)
COPY --chown=root:kenobi MIBs/* /usr/share/snmp/mibs

# Overwrite the flawed SNMPv2-PDU
RUN mv /usr/share/snmp/mibs/SNMPv2-PDU /usr/share/snmp/mibs/ietf/SNMPv2-PDU

# Copy the SNMP configurations over. Make sure user kenobi (belonging to group kenobi)
# can edit the files so that people don't go mad with the lack of sudo(8)
COPY --chown=root:kenobi conf/snmp.conf /etc/snmp/snmp.conf
COPY --chown=root:kenobi conf/snmpd.conf /etc/snmp/snmpd.conf

# Copy the initial snmptrapd configuration
COPY --chown=root:kenobi conf/snmptrapd.p2.conf /etc/snmp/snmptrapd.p2.conf

# Copy the service definitions
COPY --chown=root:kenobi ./conf/supervisord.conf /etc/supervisord.conf

# Create a directory for storing all the scripts
RUN mkdir /home/kenobi/bin && chown kenobi:kenobi /home/kenobi/bin

# Copy the helper scripts for sending traps
COPY --chown=kenobi:kenobi --chmod=0775 ./scripts/helpers/* /home/kenobi/bin

# Be nice and include the auxiliary bin directory in the PATH
ENV PATH=${PATH}:/home/kenobi/bin

# Create a directory for storing custom MIBs
RUN mkdir /home/kenobi/mibs && chown kenobi:kenobi /home/kenobi/mibs

# Make kenobi's home directory world-{listable,readable} so that snmptrapd
# (i.e. supervisord) can read custom MIB definitions and execute handlers.
RUN chmod 0777 /home/kenobi
