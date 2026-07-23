FROM ghcr.io/netmgmt/base:latest

# Add handy metadata
LABEL \
    org.opencontainers.image.title="Lab 03"                       \
    org.opencontainers.image.description="Rsyslog-enabled images"

# Install other goodies:
#    rsyslog(8): the rsyslog daemon
RUN apt update && apt install -y \
    rsyslog

# Clean up the apt(8) cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Add kenobi to the adm group so that it can open /var/log/syslog
RUN usermod -aG adm kenobi

# Remove the imklog module from syslog's config. It'll emit a warning
# when failing to open /proc/kmsg. Maybe running in privileged mode
# can circumvent the issue, but we don't really care ¯\_(ツ)_/¯
RUN sed -i '/imklog/s/^/#/' /etc/rsyslog.conf

# Comment 'su root adm' to avoid authority errors on logrotate command. We'll allow kenobi to modify the logrotate configuration files
RUN sed -i 's/^[[:space:]]*su[[:space:]]\+root[[:space:]]\+adm/# &/' /etc/logrotate.conf

# Allow kenobi to modify the rsyslogd(8) configuration file and add more
# under /etc/rsyslog.d
RUN chown    root:kenobi /etc/rsyslog.conf   && \
    chmod           0664 /etc/rsyslog.conf   && \
    chown -R root:kenobi /etc/rsyslog.d      && \
    chmod -R        0664 /etc/rsyslog.d      && \
    chmod           0775 /etc/rsyslog.d      && \
    chown -R root:kenobi /var/log            && \
    chmod -R       g+rwX /var/log            && \
    chown -R root:kenobi /var/lib/logrotate  && \
    chmod           0775 /var/lib/logrotate

# Create a symbolic link to the deliverable 30-lab03-uah.conf configuration file
RUN ln -s /home/kenobi/.deliverables/30-lab03-uah.conf /etc/rsyslog.d/30-lab03-uah.conf
RUN ln -s /home/kenobi/.deliverables/logrotate-lab03-uah /etc/logrotate.d/logrotate-lab03-uah


# Create a symbolic link to the deliverable 30-lab03-uah.conf configuration file
RUN ln -s /home/kenobi/.deliverables/30-lab03-uah.conf /etc/rsyslog.d/30-lab03-uah.conf
RUN ln -s /home/kenobi/.deliverables/logrotate-lab03-uah /etc/rsyslog.d/logrotate-lab03-uah


# Copy the service definitions
COPY --chown=root:kenobi ./conf/supervisord.conf /etc/supervisord.conf
