FROM alpine:latest
LABEL maintainer="Wolfereign"

# Update Packages and Install Needed Packages
RUN apk --repository "http://dl-cdn.alpinelinux.org/alpine/edge/testing" \
        --repository "http://dl-cdn.alpinelinux.org/alpine/edge/main" \
        --no-cache add deluge py2-pip \
         && pip2 --no-cache-dir install service_identity twisted \
         && apk --no-cache del py2-pip \

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

# Supervisord will run deluge, deluge-webui, and OpenVPN(PIA)
ENTRYPOINT ["/bin/sh","/root/entrypoint.sh"]
