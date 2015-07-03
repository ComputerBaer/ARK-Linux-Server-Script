# ARK-Linux-Server-Script
An advanced ark linux server script that allows you to do a number of things for your ark server without having to stress through managing a server. This script was made for personal use, but was released because of how usful it could be to some people. Some features incldude a server installer, updater, restarter, save backup script and more.

# Features (1.1.8)
- Server Starter/Stopper/Restarter
- World save backup script
- Server Installer/Updater
- Dependency Checker
  - CURL
  - GIT
  - SCREEN
- Vast Configuration File
  - Server/Admin Password
  - Hostname
  - Server Port/Querry Port
  - Max Players
  - Set Ip Address
  - All base config options.
    - Player Downloads
    - Crosshair
    - Hardcore
    - Save Timer
    - AFK Timer
    - etc...
  - All server modifiers
    - Hunger Usage
    - Taming Time
    - etc...
  - Map Name (advanced usage)
  - Dificulty modifier.
- Ability to run Multiple servers.
- IPTables Checker (Server/Querry Ports)
- ArkServers Integration
- Script security and integrity checks.
- Script auto update checker and installer.
- Ability to use with other similar games. (advanced)
- Server Status Script (View Settings)
- **And More always being added!**


# Recently Changed/Updated (1.1.8)
- Auto-Save Timer Added
- AFK-Timer Added
- Fixed Formatting Issues/Conflicts
- Enabled setting IP address.

# Upcoming Features
- Server automatic updater.
  - Update checker
  - update installer

# How To Install
Open SSH, direct to your GameServer folder. Then run the following command:
````
wget https://raw.githubusercontent.com/Zendrex/ARK-Linux-Server-Script/master/arkserver.sh && chmod +x arkserver.sh && ./arkserver.sh
````

# Contributers
- Zendrex
- ComputerBaer (Added port params and features for hostname)
