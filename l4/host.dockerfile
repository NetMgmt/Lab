FROM ghcr.io/netmgmt/base:latest

# Add handy metadata
LABEL \
    org.opencontainers.image.title="Lab 04"                   \
    org.opencontainers.image.description="ssh-enabled images"

# Install other goodies:
#
#          rsyslog(8): the rsyslog daemon
#             sshd(8): ssh server
#          sshpass(1): non-interactive ssh password provider
#             sudo(8): execute commands as other users
#
# Bear in mind ansible(1) pulls in a ton of other goodies including
# python3(1) and openssh-client (i.e. ssh(1)). We don't *really* have
# to install ansible or openssh-client on the target hosts, but maintaining
# separate images will become a burden for sure. That's why we'll install
# everything both the manager and hosts need and reuse the resulting image.
RUN apt-get update && apt-get install -y \
    rsyslog        \
    openssh-server \
    sudo

# Let kenobi run any command through sudo without prompting for the password
RUN echo "kenobi ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Simply leverage the default value, we don't expect this to be set at
# build time with '--build-arg'.
ARG SSH_DIR=/home/kenobi/.ssh

# Offline SSH key distribution: careful with permissions!
RUN mkdir               ${SSH_DIR} && \
    chmod           700 ${SSH_DIR} && \
    chown kenobi:kenobi ${SSH_DIR}
COPY --chmod=0600 --chown=kenobi:kenobi ./conf/host/authorized_keys ${SSH_DIR}/authorized_keys

# Copy the service definitions and let kenobi modify it to
# add services as needed.
COPY --chown=root:kenobi --chmod=0664 ./conf/host/supervisord.conf /etc/supervisord.conf
