FROM alpine:latest
LABEL maintainer="Wolfereign"

# Update Packages and Install Needed Packages
RUN apk add --update --no-cache \ 
        wget \
        supervisor \
        ca-certificates &&\
    apk add deluge --update-cache --repository http://nl.alpinelinux.org/alpine/edge/testing \
    rm -rf /var/cache/apk/*

# UID/GID
ENV USER_ID=866 \
    GROUP_ID=866

# Deluge Auth
ENV DELUGED_USER=deluge \
    DELUGED_PASS=deluge

# Configure Settings
RUN adduser --system \
            --uid "${User_ID}" \
            --group --gid "${Group_ID}" \
            --gecos "Deluge Service" \
            --disabled-password \
            --home /var/lib/deluge \
            deluge 
     

# Copy the supervisord configuration file
COPY supervisord.conf /etc/supervisord.conf

# Create needed volume directories
VOLUME /config \
       /torrents

# Expose Needed Ports (In Order, by line: Deluge Service, Deluge WebUI, Torrent Incoming Port)
EXPOSE 58846/tcp \
        8112/tcp \
        53160/tcp 53160/udp

# Copy entrypoint.sh into image
COPY entrypoint.sh /root/entrypoint.sh

# Supervisord will run deluge, deluge-webui, and OpenVPN(PIA)
ENTRYPOINT ["entrypoint.sh"]