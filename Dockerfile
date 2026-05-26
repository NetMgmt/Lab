# Let's work off of the latest Ubuntu LTS image
FROM ubuntu:26.04

# Add handy metadata
LABEL org.opencontainers.image.vendor="Universidad de Alcalá (UAH)"
LABEL org.opencontainers.image.source="https://github.com/NetMgmt/gar"
LABEL org.opencontainers.image.authors="Departamento de Automática"

# Make Ubuntu pull manpages
RUN sed -i 's:^path-exclude=/usr/share/man:#path-exclude=/usr/share/man:' /etc/dpkg/dpkg.cfg.d/excludes

# Install manpage goodies
RUN apt update && apt -y install man

# Trump the nasty default script impersonating man(1)
RUN mv /usr/bin/man.REAL /usr/bin/man

# Install basic goodies needed on all images:
#
#       less(1): the default more(1) is quite a pain...
#       lsof(1): an easy way to check open sockets (i.e. FDs)
#   iproute2(8): ifconfig has been deprecated for some time now...
#       ping(8): to ease checking connectivity
#        vim(1): a sane (:P) text editor
#       nano(1): an enhanced free Pico clone
# supervisor(1): a lightweight init system
RUN apt install -y \
    less \
    lsof \
    iproute2 \
    iputils-ping \
    vim \
    nano \
    supervisor

# Reinstall some packages to pull the manpages
# RUN apt reinstall -y \
#     bsdutils

# Clean up the apt(8) cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Setup a user for supervisord
RUN useradd --no-create-home --system supervisord

# Setup a non-root user to avoid freaking people out. Add the user to the
# supervisord group to allow it to run supervisorctl(1)
RUN useradd --create-home --shell /bin/bash --groups supervisord kenobi

# Use the user's home directory by default
WORKDIR /home/kenobi

# Get some RHEL flair in the prompt
RUN echo "PS1='[\u@\h \W]\$ '" >> .bashrc

# Start supervisord as PID 1 to handle stuff!
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
