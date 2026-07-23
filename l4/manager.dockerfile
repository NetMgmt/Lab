FROM ghcr.io/netmgmt/base:latest

# Add handy metadata
LABEL \
    org.opencontainers.image.title="Lab 04"                   \
    org.opencontainers.image.description="ssh-enabled images"

# Install other goodies:
#
#      ssh(1): ssh client
#  sshpass(1): non-interactive ssh password provider
#  ansible(1): the Ansible configuration management platform.
#
# Bear in mind ansible(1) pulls in a ton of other goodies including
# python3(1) and openssh-client (i.e. ssh(1)). We don't *really* have
# to install ansible or openssh-client on the target hosts, but maintaining
# separate images will become a burden for sure. That's why we'll install
# everything both the manager and hosts need and reuse the resulting image.
RUN apt-get update && apt-get install -y \
    openssh-client \
    ansible

# Install the necessary net-snmp goodies (MIBs should be already
# downloaded, but it doesn't hurt to do it again...). We'll install
# the necessary stuff for both the agent and the manager so as not
# to duplicate maintenance efforts...
RUN apt update && apt install -y snmp snmp-mibs-downloader snmpd snmptrapd libsnmp-dev && download-mibs

# Clean up the apt(8) cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Simply leverage the default value, we don't expect this to be set at
# build time with '--build-arg'.
ARG SSH_DIR=/home/kenobi/.ssh

# Offline SSH key distribution: careful with permissions!
RUN mkdir               ${SSH_DIR} && \
    chmod           700 ${SSH_DIR} && \
    chown kenobi:kenobi ${SSH_DIR}
COPY --chmod=0600 --chown=kenobi:kenobi ./conf/manager/id_rsa     ${SSH_DIR}/id_rsa
COPY --chmod=0644 --chown=kenobi:kenobi ./conf/manager/id_rsa.pub ${SSH_DIR}/id_rsa.pub

# Ansible inventory and config: tweak permissions so that kenobi can read them
RUN mkdir -p /etc/ansible   && \
    chmod 0775 /etc/ansible && \
    chown root:kenobi /etc/ansible
COPY --chown=root:kenobi ./conf/manager/ansible_hosts /etc/ansible/hosts
COPY --chown=root:kenobi ./conf/manager/ansible.cfg   /etc/ansible/ansible.cfg

# Copy the service definitions
COPY --chown=root:kenobi ./conf/manager/supervisord.conf /etc/supervisord.conf
