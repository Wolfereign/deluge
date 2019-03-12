FROM ubuntu:rolling
LABEL maintainer="Wolfereign"

# Create User & Directories
RUN mkdir -p /config \
	&& chown "999":"999" /config \
	&& addgroup --system --gid "999" deluge \
	&& adduser --system --uid "999" --gid "999" --home /config deluge

# Install Needed Packages
RUN DEBIAN_FRONTEND=nointeractive apt-get update && apt-get install -y \
		deluged \
		deluge-console \
		deluge-web \
		dumb-init \
	&& apt-get --purge autoremove -y \
	&& rm -rf /tmp/* /var/tmp/* /var/lib/apt/* 

# Copy entrypoint.sh into image
COPY entrypoint.sh /root/entrypoint.sh

# Expose Needed Ports (In Order, by line: Deluge WebUI, Deluge Daemon, Torrent Incoming Port)
EXPOSE 8112/tcp 58846/tcp 53160/tcp 53160/udp

# Supervisord will run deluged and deluge-webui
ENTRYPOINT ["/usr/bin/dumb-init", "/bin/sh", "/root/entrypoint.sh"]
