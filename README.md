# deluge-simple
Run the Deluge torrent server simply and reproducably!

## Branches/Tags
- Latest/Master = Deluge Daemon (w/ Console) + Web Server (Based on Ubuntu:Rolling)
- Daemon = Deluge Daemon (w/ Console) (Based on Ubuntu:Rolling)
- Web = Deluge Web Server (Based on Ubuntu:Rolling)

## Available Settings
- Required Ports
  - 8112/tcp (Web UI)(Latest/Web)
  - 58846/tcp (Daemon Management/RemoteUI)(Latest/Daemon)
  - 56638/tcp&udp (Incoming/Outgoing Torrent Connections)(Latest/Daemon)
- Persistant Settings or Storage
  - Config Files (/deluge/config)
  - Torrent Files (/deluge/torrents)
- Daemon Username and Password ENV Vars (for RemoteUI/RemoteWeb)
  - dname (default = deluge-simple)
  - dpass (default = deluge-simple)
- Web Server Password
  - Default = deluge
  - It will ask you to change it, in the interface, the first time you login

## Example 1: Single Container Using Latest Tag
```
Docker Container Run -d \
  --name deluge \
  --restart="unless-stopped" \
  --mount type=volume,source=deluge,target=/deluge \
  -p 8112:8112 \
  -p 58846:58846 \
  -p 56638:56638 \
  -e dname="customUserName"
  -e dpass="customPass"
  wolfereign/deluge-simple:latest
```

## Example 2: Single Container Using Daemon Tag
```
Docker Container Run -d \
  --name deluge \
  --restart="unless-stopped" \
  --mount type=volume,source=deluge,target=/deluge \
  -p 58846:58846 \
  -p 56638:56638 \
  -e dname="customUserName"
  -e dpass="customPass"
  wolfereign/deluge-simple:daemon
```

## Example 3: Multi Container Using Compose File
```
```
