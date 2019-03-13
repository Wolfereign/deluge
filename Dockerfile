FROM ubuntu:rolling
LABEL maintainer="Wolfereign"

# Create User & Directories
RUN mkdir -p /deluge/config /deluge/torrents \
	&& chown "999":"999" /deluge \
	&& addgroup --system --gid "999" deluge \
	&& adduser --system --uid "999" --gid "999" --home /deluge deluge

# Install Needed Packages
RUN DEBIAN_FRONTEND=nointeractive apt-get update && apt-get install -y \
		deluged \
		deluge-console \
		dumb-init \
	&& apt-get --purge autoremove -y \
	&& rm -rf /tmp/* /var/tmp/* /var/lib/apt/* 

# Copy entrypoint.sh into image
COPY entrypoint.sh /root/entrypoint.sh

# Expose Needed Ports (In Order: Deluge Daemon, Torrent Incoming/Outgoing Ports)
EXPOSE 58846/tcp 56638/tcp 56638/udp

# Use dumb-init to reap zombies and such
ENTRYPOINT ["/usr/bin/dumb-init", "/bin/sh", "/root/entrypoint.sh"]
