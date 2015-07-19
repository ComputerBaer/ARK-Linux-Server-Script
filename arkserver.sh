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
version="1.2.7"

if [ -f version.ini ]; then
    rm version.ini
fi

# Check Script Version
if [ $scriptUpdater = "true" ]; then
    clear
    echo -e "$YELLOW Checking for script updates... $RESET"
    curl https://raw.githubusercontent.com/Zendrex/ARK-Linux-Server-Script/master/version.ini -o version.ini -#
    source version.ini
    # Main Shell Script
    if [ $arkserver_Current != $arkserver ]; then
        echo -e " Script update available! (Main Script)"
        echo -e; echo -e "$YELLOW Downloading shell file. $RESET"
        curl https://raw.githubusercontent.com/Zendrex/ARK-Linux-Server-Script/master/arkserver.sh -o arkserver.sh -#
        echo -e; echo -e "$GREEN File overwritten. Please restart the script. $RESET"
        exit 0
    fi
    # Backup Server Script
    if [ $backupserver_Current != $backupserver ]; then
        echo -e " Script update available! (Backup Script)"
        echo -e; echo -e "$YELLOW Downloading script file. $RESET"
        curl https://raw.githubusercontent.com/Zendrex/ARK-Linux-Server-Script/master/.serverscript/backupserver -o backupserver -#
    fi
    # Install Server Script
    if [ $installserver_Current != $installserver ]; then
        echo -e " Script update available! (Install Script)"
        echo -e; echo -e "$YELLOW Downloading script file. $RESET"
        curl https://raw.githubusercontent.com/Zendrex/ARK-Linux-Server-Script/master/.serverscript/installserver -o installserver -#
    fi
    # Server Status Script
    if [ $serverstatus_Current != $serverstatus ]; then
        echo -e " Script update available! (Status Script)"
        echo -e; echo -e "$YELLOW Downloading script file. $RESET"
        curl https://raw.githubusercontent.com/Zendrex/ARK-Linux-Server-Script/master/.serverscript/serverstatus -o serverstatus -#
    fi
    # Server Start Script
    if [ $startserver_Current != $startserver ]; then
        echo -e " Script update available! (Start Script)"
        echo -e; echo -e "$YELLOW Downloading script file. $RESET"
        curl https://raw.githubusercontent.com/Zendrex/ARK-Linux-Server-Script/master/.serverscript/startserver -o startserver -#
    fi
    # Server Stop Script
    if [ $stopserver_Current != $stopserver ]; then
        echo -e " Script update available! (Stop Script)"
        echo -e; echo -e "$YELLOW Downloading script file. $RESET"
        curl https://raw.githubusercontent.com/Zendrex/ARK-Linux-Server-Script/master/.serverscript/stopserver -o stopserver -#
    fi
    # Update Check Script
    if [ $updatecheck_Current != $updatecheck ]; then
        echo -e " Script update available! (Update Check Script)"
        echo -e; echo -e "$YELLOW Downloading script file. $RESET"
        curl https://raw.githubusercontent.com/Zendrex/ARK-Linux-Server-Script/master/.serverscript/update_check -o update_check -#
    fi
    # Server Updater Script
    if [ $updateserver_Current != $updateserver ]; then
        echo -e " Script update available! (Server Updater Script)"
        echo -e; echo -e "$YELLOW Downloading script file. $RESET"
        curl https://raw.githubusercontent.com/Zendrex/ARK-Linux-Server-Script/master/.serverscript/updateserver -o updateserver -#
    fi
    # Server Viewer Script
    if [ $viewserver_Current != $viewserver ]; then
        echo -e " Script update available! (View Server Script)"
        echo -e; echo -e "$YELLOW Downloading script file. $RESET"
        curl https://raw.githubusercontent.com/Zendrex/ARK-Linux-Server-Script/master/.serverscript/viewserver -o viewserver -#
    fi
    if [ -f configuration.ini ]; then
        # Config Version Checker
        if [ $ConfigVersion != $liveConfig ]; then
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
    fi
    echo -e " All scripts up to date!"
else
    echo -e "$RED Script Update Checker Disabled $RESET"
fi

shopt -s nocasematch

# Check for config file.
if [ -f configuration.ini ]; then
    source configuration.ini

    if [[ $InfoNotify =~ true ]]; then
        sleep 1s
        echo -e "$YELLOW Configuration file found. $RESET"; echo -e
    fi
    
    # Saftey Switch Notification
    if [[ ! $SafetySwitch =~ true ]]; then
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
if [[ $InfoNotify =~ true ]]; then
    sleep 0.5s
    echo -e "$YELLOW Checking dependencies $RESET"
fi

if [ -x /usr/bin/curl ]; then
    if [[ $InfoNotify =~ true ]]; then
        sleep 0.5s
        echo -e "$GREEN CURL installed $RESET"
    fi
else
    echo -e"$ERR Script detects that CURL is not installed. Installing now."
    sudo apt-get install curl
    echo "$YELLOW CURL now installed $RESET"
fi

if [ -x /usr/bin/screen ]; then
    if [[ $InfoNotify =~ true ]]; then
        sleep 0.5s
        echo -e "$GREEN SCREEN installed $RESET"
    fi
else
    echo -e "$ERR Script detects that SCREEN is not installed. Installing now."
    sudo apt-get install screen
    echo "$YELLOW SCREEN now installed $RESET"
fi

if [ -x /usr/bin/git ]; then
    if [[ $InfoNotify =~ true ]]; then
        sleep 0.5s
        echo -e "$GREEN GIT installed $RESET"
    fi
else
    echo -e "$ERR Script detects that GIT is not installed. Installing now."
    sudo apt-get install git
    echo "$YELLOW GIT now installed. $RESET"
fi


# IPTables Check
if [[ $InfoNotify =~ true ]]; then
    sleep 0.5s; echo -e
    echo -e "$YELLOW Checking IPTables $RESET"
fi

if [ -z "$(iptables -nL | grep $GamePort)" ]; then
    sleep 0.5s
    echo -e " IPTables (Game Port):$RED MISSING $RESET"
    echo -e " Adding IPTables requirements. (Game Port)"
    iptables -I INPUT -p udp --dport $GamePort -j ACCEPT
    iptables -I INPUT -p tcp --dport $GamePort -j ACCEPT
else
    if [[ $InfoNotify =~ true ]]; then
        sleep 0.5s
        echo -e " IPTables (Game Port):$GREEN OK $RESET"
    fi
fi

if [ -z "$(iptables -nL | grep $QueryPort)" ]; then
    sleep 0.5s
    echo -e " IPTables (Query Port):$RED MISSING $RESET"
    echo -e " Adding IPTables requirements. (Query Port)"
    iptables -I INPUT -p udp --dport $QueryPort -j ACCEPT
    iptables -I INPUT -p tcp --dport $QueryPort -j ACCEPT
else
    if [[ $InfoNotify =~ true ]]; then
        sleep 0.5s
        echo -e " IPTables (Query Port):$GREEN OK $RESET"
    fi
fi

if [ -z "$(iptables -nL | grep $RconPort)" ]; then
    sleep 0.5s
    echo -e " IPTables (RCON Port):$RED MISSING $RESET"
    echo -e " Adding IPTables requirements. (RCON Port)"
    iptables -I INPUT -p udp --dport $RconPort -j ACCEPT
    iptables -I INPUT -p tcp --dport $RconPort -j ACCEPT
else
    if [[ $InfoNotify =~ true ]]; then
        sleep 0.5s
        echo -e " IPTables (RCON Port):$GREEN OK $RESET"
    fi
fi


# Server Script Check
if [[ $InfoNotify =~ true ]]; then
    sleep 0.5s; echo -e
    echo -e "$YELLOW Checking script files. $RESET"
    sleep 1s
fi

#####################################[ SERVER SCRIPT SCAN ]#####################################

# Check if serverscript directory is already made.
if [ ! -d .serverscript ]; then
    echo -e "$ERR Unable to find script directory. Creating it."
    mkdir .serverscript
    sleep 1s
    echo -e; echo -e "$YELLOW Directory created. $RESET"
fi

cd .serverscript

# Functions Script
if [ ! -f _functions ]; then
    echo -e "$YELLOW Functions Script $RESET"
    curl https://raw.githubusercontent.com/Zendrex/ARK-Linux-Server-Script/master/.serverscript/_functions -o _functions -#
    chmod 777 _functions
fi

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

# Update Check Script
if [ ! -f update_check ]; then
    echo -e "$YELLOW Update Check Script $RESET"
    curl https://raw.githubusercontent.com/Zendrex/ARK-Linux-Server-Script/master/.serverscript/update_check -o update_check -#
    chmod 777 update_check
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

# Parameter Script
if [ ! -f parameters_check ]; then
    echo -e "$YELLOW Parameter Script $RESET"
    curl https://raw.githubusercontent.com/Zendrex/ARK-Linux-Server-Script/master/.serverscript/parameters_check -o parameters_check -#
    chmod 777 parameters_check
fi

# Formatting File
if [ ! -f formatting.ini ]; then
    echo -e "$YELLOW Formatting $RESET"
    curl https://raw.githubusercontent.com/Zendrex/ARK-Linux-Server-Script/master/.serverscript/formatting.ini -o formatting.ini -#
fi

#####################################[ SERVER SCRIPT SCAN ]#####################################

if [[ $InfoNotify =~ true ]]; then
    echo -e " All scripts found."
    echo -e; sleep 0.5s
fi


# Commands
help () {
    echo -e; echo -e "$WHITE Use the following commands: $RESET"
    echo -e; echo -e "$CYAN ./arkserver.sh <start|stop|view|status|install|update|updatecheck|backup> $RESET"
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

updatecheck () {
    clear
    ./update_check
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
