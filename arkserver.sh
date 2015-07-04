#!/bin/bash

# Colors 
RED='\e[1;31m'
GREEN='\e[1;32m'
YELLOW='\e[1;33m'
CYAN='\e[1;36m'
WHITE='\e[1;37m'
RESET='\e[0m'
# Messages
ERR='\e[1;31m ERROR\e[0m'

# Version Checker
# Don't change this number.
version="1.2.1"

if [ -f version.ini ]; then
    rm version.ini
fi

# Download Version File
curl https://raw.githubusercontent.com/Zendrex/ARK-Linux-Server-Script/master/version.ini -o version.ini -#
clear
echo -e; echo -e "$YELLOW Checking version with github. $RESET"
source version.ini

# Check Script Version
if [ $version != $arkserver ]; then
    echo -e " Script update available!"
    echo -e; echo -e "$YELLOW Downloading shell file. $RESET"
    curl https://raw.githubusercontent.com/Zendrex/ARK-Linux-Server-Script/master/arkserver.sh -o arkserver.sh -#
    echo -e; echo -e "$GREEN File overwritten. Please restart the script. $RESET"
    exit 0
else
    echo -e " Up to date!"; echo -e
fi


# Check for config file.
if [ -f configuration.ini ]; then
source configuration.ini

    if [ -f $safetyNotify = True ]; then
        sleep 1s
        echo -e "$YELLOW Configuration file found. $RESET"; echo -e
    fi
    
    # Config Version Checker
    if [ $configVersion != $liveConfig ]; then
        echo -e "$ERR You have an outdated configuration file!"
        echo -e "$YELLOW There is a config update! Any config updates are important to the script. $RESET"
        echo -e "$YELLOW The script will make a backup of your current config. However you will have to $RESET"
        echo -e "$YELLOW edit the config file again. Sorry for the flaw in this design of the script. $RESET"
        sleep 1s
        echo -e; mv configuration.ini configuration_backup.ini
        echo -e "$YELLOW File backed up. Downloading new config file. $RESET"
        curl https://raw.githubusercontent.com/Zendrex/ARK-Linux-Server-Script/master/configuration.ini -o configuration.ini -#
        echo -e; echo -e "$GREEN Configuration file updated. Please edit your config once again then restart the script. $RESET"
        echo -e "$GREEN Most options you can simply copy and paste as most config updates are additions or formatting. $RESET"
        echo -e; exit 0
    fi
    
    # Saftey Switch Notification
    if [ $safetySwitch = False ]; then
        echo -e =========================================================================
        echo -e
        echo -e "$ERR You have yet to edit the config file!"
        echo -e " Please do so and alter the 'Safety Switch' to TRUE once done."
        echo -e
        echo -e =========================================================================
        echo -e
        exit 0
    fi

else
    echo -e "$ERR No configuration file found. Downloading from github now."
    curl https://raw.githubusercontent.com/Zendrex/ARK-Linux-Server-Script/master/configuration.ini -o configuration.ini -#; echo -e
    echo -e "$GREEN Configuration file download was successful."
    echo -e " Please edit the config file before running the script again. $RESET"
    echo -e; exit 0
fi


# Hard dep's check.
if [ -x /usr/bin/curl ]; then
    if [ $safetyNotif = True ]; then
		sleep 0.5s
        echo -e "$GREEN CURL installed $RESET"
    fi
else
    echo -e"$ERR Script detects that CURL is not installed. Installing now."
    sudo apt-get install curl
    echo "$YELLOW CURL now installed $RESET"
fi

if [ -x /usr/bin/screen ]; then
    if [ $safetyNotif = True ]; then
		sleep 0.5s
        echo -e "$GREEN SCREEN installed $RESET"
    fi
else
    echo -e "$ERR Script detects that SCREEN is not installed. Installing now."
    sudo apt-get install screen
    echo "$YELLOW SCREEN now installed $RESET"
fi

if [ -x /usr/bin/git ]; then
    if [ $safetyNotif = True ]; then
		sleep 0.5s
        echo -e "$GREEN GIT installed $RESET"
    fi
else
    echo -e "$ERR Script detects that GIT is not installed. Installing now."
    apt-get install git
    echo "$YELLOW GIT now installed. $RESET"
fi


# IPTables Check
if [ $safetyNotif = True ]; then
	echo -e; sleep 0.5s
    echo -e "$YELLOW Checking IPTables $RESET"
	sleep 0.5s
fi

if [ -z "$(iptables -nL | grep $queryPort)" ]; then
    echo -e " IPTables (Query Port):$RED MISSING $RESET"
    echo -e " Adding IPTables requirements. (Query Port)"
    iptables -I INPUT -p udp --dport $queryPort -j ACCEPT
    iptables -I INPUT -p tcp --dport $queryPort -j ACCEPT
else
    if [ $safetyNotif = True ]; then
        echo -e " IPTables (Query Port):$GREEN OK $RESET"
    fi
fi


# Check if serverscript directory is already made.
if [ $safetyNotif = True ]; then
	echo -e; sleep 0.5s
    echo -e "$YELLOW Checking script files. $RESET"
    sleep 1s
fi
#####################################[ SERVER SCRIPT SCAN ]#####################################
if [ ! -d .serverscript ]; then
    echo -e "$ERR Unable to find script directory. Creating it."
    mkdir .serverscript
    sleep 1s
    echo -e; echo -e "$YELLOW Directory created. $RESET"
fi
cd .serverscript
# Start Server Script
if [ ! -f startserver ]; then
    echo -e "$YELLOW Start Script $RESET"
    curl https://raw.githubusercontent.com/Zendrex/ARK-Linux-Server-Script/master/.serverscript/startserver -o startserver -#
    chmod 777 startserver
fi
# Stop Server Script
if [ ! -f stopserver ]; then
    echo -e "$YELLOW Stop Script $RESET"
    curl https://raw.githubusercontent.com/Zendrex/ARK-Linux-Server-Script/master/.serverscript/stopserver -o stopserver -#
    chmod 777 stopserver
fi
# View Server Script
if [ ! -f viewserver ]; then
    echo -e "$YELLOW View Script $RESET"
    curl https://raw.githubusercontent.com/Zendrex/ARK-Linux-Server-Script/master/.serverscript/viewserver -o viewserver -#
    chmod 777 viewserver
fi
# Install Server Script
if [ ! -f installserver ]; then
    echo -e "$YELLOW Install Script $RESET"
    curl https://raw.githubusercontent.com/Zendrex/ARK-Linux-Server-Script/master/.serverscript/installserver -o installserver -#
    chmod 777 installserver
fi
# Update Server Script
if [ ! -f updateserver ]; then
    echo -e "$YELLOW Update Script $RESET"
    curl https://raw.githubusercontent.com/Zendrex/ARK-Linux-Server-Script/master/.serverscript/updateserver -o updateserver -#
    chmod 777 updateserver
fi
# Backup Server Script
if [ ! -f backupserver ]; then
    echo -e "$YELLOW Backup Script $RESET"
    curl https://raw.githubusercontent.com/Zendrex/ARK-Linux-Server-Script/master/.serverscript/backupserver -o backupserver -#
    chmod 777 backupserver
fi
# Server Status Script
if [ ! -f serverstatus ]; then
    echo -e "$YELLOW Server Status Script $RESET"
    curl https://raw.githubusercontent.com/Zendrex/ARK-Linux-Server-Script/master/.serverscript/serverstatus -o serverstatus -#
	chmod 777 serverstatus
fi
# Formatting File
if [ ! -f formatting.ini ]; then
    echo -e "$YELLOW Formatting $RESET"
    curl https://raw.githubusercontent.com/Zendrex/ARK-Linux-Server-Script/master/.serverscript/formatting.ini -o formatting.ini -#
fi
#####################################[ SERVER SCRIPT SCAN ]#####################################
if [ $safetyNotif = True ]; then
    echo -e " All scripts found."
	echo -e; sleep 0.5s
fi


# Commands
help () {
    echo -e; echo -e "$WHITE Use the following commands: $RESET"
    echo -e; echo -e "$CYAN ./arkserver.sh <start|stop|view|status|install|update|backup> $RESET"
	echo -e; echo -e
}

start () {
    clear
    ./startserver
}

stop () {
    clear
    ./stopserver
}

view () {
    clear
    ./viewserver
}

install () {
    clear
    ./installserver
}

update () {
    clear
    ./updateserver
}

backup () {
    clear
    ./backupserver
}

status () {
	clear
	./serverstatus
}

[ "$1" = "" ] && {
    help
    exit
}

$*
echo
exit 0
