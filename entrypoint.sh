#!/bin/bash

# Ensure Deluge UID/GID are correctly set.
groupmod --gid "$GROUP_ID" deluge || true
usermod --uid="$USER_ID" --gid="$GROUP_ID" || true

# Verify Directory Structure
mkdir -p /torrents/autoadd
mkdir -p /torrents/completed
mkdir -p /torrents/inprogress
mkdir -p /torrents/torrent-files

# Ensure deluge owns the needed directories
chown -R deluge:deluge /config
chown -R deluge:deluge /torrents

# Add supplied auth
echo $DELUGED_USER:$DELUGED_PASS:10 >> /config/auth

# Start Supervisord
supervisord -c /etc/supervisord.conf