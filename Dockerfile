FROM ubuntu:18.04
LABEL maintainer="Wolfereign"

# Update Packages and Install Needed Packages
RUN apt-get update && \
  && apt-get install -y tzdata gnupg-utils \
  && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 249AD24C \
  && echo "deb http://ppa.launchpad.net/deluge-team/ppa/ubuntu bionic main " >> /etc/apt/sources.list.d/deluge.list \
  && apt-get update \
  && apt-get install -y \
        deluged \
        deluge-console \
        deluge-web \
        supervisor \
  && apt-get --purge remove -y gnupg-utils \
  && apt-get --purge autoremove -y \
  && rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*

# Create Needed Mount Points
VOLUME /config \
       /torrents

# UID/GID
ENV USER_ID=866 \
    GROUP_ID=866

# Configure Settings
RUN addgroup -g "${GROUP_ID}" -S deluge &&\
    adduser -S -D -u "${USER_ID}" -G deluge -g "Deluge Service" -h /config deluge

# Expose Needed Ports (In Order, by line: Deluge Service, Deluge WebUI, Torrent Incoming Port)
EXPOSE 8112/tcp \
        58846/tcp \
        53160/tcp 53160/udp

# Copy the supervisord configuration file
COPY supervisord.conf /etc/supervisord.conf

# Copy entrypoint.sh into image
COPY entrypoint.sh /root/entrypoint.sh

# Supervisord will run deluged and deluge-webui
ENTRYPOINT ["/bin/sh","/root/entrypoint.sh"]
