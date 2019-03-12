#!/usr/bin/dumb-init /bin/sh

# Quit Script on Error
set -e

# Ensure Deluge UID/GID are correctly set.
groupmod --gid "$GROUP_ID" deluge || true
usermod --uid "$USER_ID" deluge || true

# Verify Directory Structure
mkdir -p /deluge/config
mkdir -p /deluge/torrents/autoadd
mkdir -p /deluge/torrents/completed
mkdir -p /deluge/torrents/inprogress
mkdir -p /deluge/torrents/torrent-files

# If default configs are missing then generate and configure them
if [ ! -f /deluge/config/core.conf ]; then

# Generate Conf Files
deluged -c /deluge/config 
deluge-console -c /deluge/config "config -s allow_remote true"
deluge-console -c /deluge/config "config -s daemon_port 58846"
deluge-console -c /deluge/config "config -s torrentfiles_location /deluge/torrents/torrent-files"
deluge-console -c /deluge/config "config -s download_location /deluge/torrents/inprogress"
deluge-console -c /deluge/config "config -s move_completed true"
deluge-console -c /deluge/config "config -s move_completed_path /deluge/torrents/completed"
deluge-console -c /deluge/config "config -s autoadd_enable true"
deluge-console -c /deluge/config "config -s autoadd_location /deluge/torrents/autoadd"
deluge-console -c /deluge/config "halt"

fi

# Ensure deluge owns the needed directories
chown -R deluge:deluge /deluge

# Start Supervisor To Manage Processes
supervisord -c /root/supervisord.conf
