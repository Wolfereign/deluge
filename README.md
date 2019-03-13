# deluge-simple
Run the Deluge torrent server simply and reproducably!

## Branches/Tags
- Master/Latest = Deluge Daemon (w/ Console) + Web Server (Based on Ubuntu:Rolling)
- Daemon = Deluge Daemon (w/ Console) (Based on Ubuntu:Rolling)
- Web = Deluge Web Server (Based on Ubuntu:Rolling)

## Available Settings
- Required Ports
  - 8112/tcp (Web UI)(For: Master/Latest,Web)
  - 58846/tcp (Daemon Management/RemoteUI)(For: Master/Latest,Daemon)
  - 56638/tcp&udp (Incoming/Outgoing Torrent Connections)(For: Master/Latest,Daemon)
- Persistant Settings or Storage
  - Config Files (/deluge/config)
  - Torrent Files (/deluge/torrents)
- Daemon Username and Password ENV Vars (for RemoteUI/RemoteWeb)
  - dname (default = deluge-simple)
  - dpass (default = deluge-simple)
- Web Server Password
  - Default = deluge
  - It will ask you to change it, in the interface, the first time you login
