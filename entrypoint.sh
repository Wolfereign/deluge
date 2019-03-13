#!/usr/bin/dumb-init /bin/sh

# Quit Script on Error
set -e

# Ensure Deluge UID/GID are correctly set.
groupmod --gid "$GROUP_ID" deluge || true
usermod --uid "$USER_ID" deluge || true

# Verify Directory Structure
mkdir -p /deluge/config

# Ensure deluge owns the needed directories
chown -R deluge:deluge /deluge

# Start Deluge Web Server
su -s /bin/bash -c "/usr/bin/deluge-web  --config=/deluge/config --loglevel=info" deluge