FROM ubuntu:24.04

# Add handy metadata
LABEL \
    org.opencontainers.image.vendor="Universidad de Alcalá (UAH)"    \
    org.opencontainers.image.source="https://github.com/NetMgmt/gar" \
    org.opencontainers.image.title="gsyslog"                         \
    org.opencontainers.image.description="rsyslog-enabled images"    \
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
#    rsyslog(8): the rsyslog daemon
# supervisor(1): our init system
RUN apt update && apt install -y \
    less \
    lsof \
    iproute2 \
    iputils-ping \
    vim \
    rsyslog \
    supervisor

# Reinstall some packages to the the documentation.
RUN apt reinstall -y \
    bsdutils

# Clean up the apt(8) cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Setup a non-root user to avoid freaking people out
RUN useradd -ms /bin/bash kenobi

# Use th user's home directory by default
WORKDIR /home/kenobi

# Log in as kenobi by default
USER kenobi

COPY ./conf/supervisord.conf /etc/supervisord.conf

# Get some RHEL flair in the prompt
RUN echo "PS1='[\u@\h \W]\$ '" >> .bashrc

# Start supervisord as PID 1 to handle stuff!
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
