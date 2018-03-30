FROM alpine:edge
LABEL maintainer="Wolfereign"

# Update Packages and Install Needed Packages
RUN apk add --update --no-cache \ 
        wget \
        supervisor \
	shadow \
	py-pip \
        ca-certificates &&\
    apk add deluge --update-cache --repository http://nl.alpinelinux.org/alpine/edge/testing &&\
    rm -rf /var/cache/apk/* &&\
    pip install incremental &&\
    pip install constantly &&\
    pip install packaging &&\
    pip install automat &&\
    pip install service_identity

# Create Needed Mount Points
VOLUME /config \
       /torrents

# UID/GID
ENV USER_ID=866 \
    GROUP_ID=866

# Configure Settings
RUN addgroup -g "${GROUP_ID}" -S deluge &&\
    adduser -S -D \
    	-u "${USER_ID}" \
        -G deluge \
        -g "Deluge Service" \
        -h /config \
        deluge

# Expose Needed Ports (In Order, by line: Deluge Service, Deluge WebUI, Torrent Incoming Port)
EXPOSE 58846/tcp \
        8112/tcp \
        53160/tcp 53160/udp

# Copy the supervisord configuration file
COPY supervisord.conf /etc/supervisord.conf

# Copy entrypoint.sh into image
COPY entrypoint.sh /root/entrypoint.sh

# Supervisord will run deluge, deluge-webui, and OpenVPN(PIA)
ENTRYPOINT ["/bin/sh","/root/entrypoint.sh"]
