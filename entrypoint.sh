#!/bin/sh

# Quit Script on Error
set -e

# Ensure Deluge UID/GID are correctly set.
groupmod --gid "$GROUP_ID" deluge || true
usermod --uid "$USER_ID" deluge || true

# Verify Directory Structure
mkdir -p /torrents/autoadd
mkdir -p /torrents/completed
mkdir -p /torrents/inprogress
mkdir -p /torrents/torrent-files

# Ensure deluge owns the needed directories
chown -R deluge:deluge /config
chown -R deluge:deluge /torrents

# If default configs are missing then generate and configure them
if [ ! -f /config/core.conf ] || [ ! -f /config/web.conf ] ; then

# Generate Conf Files
deluged -c /config && deluge-console -c /config "config" && deluge-console -c /config "halt"

# Edit Conf Files To Image/Container Environment
sed -i 's#\("move_completed_path": \)\(.*\)#\1"/torrents/completed",#' /config/core.conf
sed -i 's#\("torrentfiles_location": \)\(.*\)#\1"/torrents/torrent-files",#' /config/core.conf
sed -i 's#\("allow_remote": \)\(.*\)#\1true,#' /config/core.conf
sed -i 's#\("download_location": \)\(.*\)#\1"/torrents/inprogress",#' /config/core.conf
sed -i 's#\("move_completed": \)\(.*\)#\1true,#' /config/core.conf
sed -i 's#\("autoadd_enable": \)\(.*\)#\1true,#' /config/core.conf
sed -i 's#\("autoadd_location": \)\(.*\)#\1"/torrents/autoadd",#' /config/core.conf

fi

# Start Supervisord
supervisord -c /etc/supervisord.conf
