FROM alpine:latest
LABEL maintainer="Wolfereign"

# Update Packages and Install Needed Packages
RUN apk add --update --no-cache \ 
    wget \
    deluge \
    supervisor \
    ca-certificates \
    && rm -rf /var/cache/apk/*

# Configure Settings
RUN adduser --system  --gecos "Deluge Service" --disabled-password --group --home /var/lib/deluge deluge \
    && 

# Copy the supervisord configuration file
COPY supervisord.conf /etc/supervisord.conf

# deluge/openvpn configuration files
VOLUME ["/config"]

# torrent data location
VOLUME ["/data"]

# Expose Deluge Service Port
EXPOSE 58846/tcp

# Expose Deluge Web UI Port
EXPOSE 8112/tcp 

# Expose Torrent Incoming Port (Only Needed for when VPN is disabled)
EXPOSE 53160/tcp 53160/udp

# Supervisord will run deluge, deluge-webui, and OpenVPN(PIA)
ENTRYPOINT ["/usr/bin/supervisord","-c","/etc/supervisord.conf"]