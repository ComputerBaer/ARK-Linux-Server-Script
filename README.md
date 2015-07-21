# ARK-Linux-Server-Script
An advanced ark linux server script that enables you to do a number of things for your ark server without having to stress through managing one. This script was made for personal use, but was released because of how useful it could be to some people. Some features include a server installer, updater, restarter, save backup script and more.

# Features
- Server Starter/Stopper/Restarter
- World save backup script
- Server Installer/Updater
- Dependency Checker
  - CURL
  - GIT
  - SCREEN
- Vast Configuration File
  - Server and Admin Password
  - Hostname
  - Game and Query Ports
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
  - Difficulty modifier.
- Ability to run Multiple servers.
- IPTables Checker (Game, Query, and RCON)
- ArkServers Integration
- Script security and integrity checks.
- Script auto update checker and installer.
- Ability to use with other similar games. (advanced)
- Server Status Script (View Settings)
- **And More always being added!**


# Recently Changed/Updated
- Server automatic updater & checker.
- Script updater changes.
  - You can now disable the updater.
  - Updater now only checks once per launch, not every script now.
- General performance increases.
- Formatting fixes.
- Added new params and removed old params.
- Fixed params arguments. AGAIN

# Upcoming Features
- Better RCON Support
- Message Relay System
- Email Notification (On Crash, etc)

# How To Install
Open SSH, direct to your GameServer folder. Then run the following command:
````
wget https://raw.githubusercontent.com/Zendrex/ARK-Linux-Server-Script/master/arkserver.sh && chmod +x arkserver.sh && ./arkserver.sh
````

# Contributors
- Zendrex
- ComputerBaer

# Testers
- Svetty (Param Patch)
