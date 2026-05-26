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

# Allow kenobi to modify the rsyslogd(8) configuration file and add more
# under /etc/rsyslog.d
RUN chown    root:kenobi /etc/rsyslog.conf && \
    chmod           0664 /etc/rsyslog.conf && \
    chown -R root:kenobi /etc/rsyslog.d    && \
    chmod -R        0664 /etc/rsyslog.d    && \
    chmod           0775 /etc/rsyslog.d

# Copy the service definitions
COPY --chown=root:kenobi ./conf/supervisord.conf /etc/supervisord.conf
