#!/bin/bash
# Test
# Colors 
RED='\e[1;31m'
GREEN='\e[1;32m'
YELLOW='\e[1;33m'
CYAN='\e[1;36m'
WHITE='\e[1;37m'
RESET='\e[0m'
# Messages
ERR='\e[1;31m ERROR\e[0m'

# Version (DO NOT CHANGE THIS)
arkserver_Current="1.3.2"

# Refresh Version
curl https://raw.githubusercontent.com/Zendrex/ARK-Linux-Server-Script/master/version.ini

shopt -s nocasematch
clear; echo -e
# Check for config file.
if [ -f configuration.ini ]; then
    source configuration.ini

    if [ $GitBranch != "master" ]; then
        echo -e "$RED Using Developer Branch! $RESET"
        echo -e; sleep 1s
        Branch="$GitBranch"
    else
        Branch="master"
    fi

    # Fix new Updater for old Configuration Versions, can be removed later
    if [ -z $ScriptUpdater ]; then
        InfoNotify=$safetyNotify
        SafetySwitch=$safetySwitch
        GamePort=$gamePort
        QueryPort=$queryPort
        RconPort=$rconPort
        ConfigVersion=$configVersion
        ScriptUpdater="true"
        rm -r .serverscript
    fi
    # End, old config fix
    
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
    curl https://raw.githubusercontent.com/Zendrex/ARK-Linux-Server-Script/$Branch/.serverscript/_functions -o _functions -#
    chmod 777 _functions
fi

# Start Server Script
if [ ! -f startserver ]; then
    echo -e "$YELLOW Start Script $RESET"
    curl https://raw.githubusercontent.com/Zendrex/ARK-Linux-Server-Script/$Branch/.serverscript/startserver -o startserver -#
    chmod 777 startserver
fi

# Stop Server Script
if [ ! -f stopserver ]; then
    echo -e "$YELLOW Stop Script $RESET"
    curl https://raw.githubusercontent.com/Zendrex/ARK-Linux-Server-Script/$Branch/.serverscript/stopserver -o stopserver -#
    chmod 777 stopserver
fi

# View Server Script
if [ ! -f viewserver ]; then
    echo -e "$YELLOW View Script $RESET"
    curl https://raw.githubusercontent.com/Zendrex/ARK-Linux-Server-Script/$Branch/.serverscript/viewserver -o viewserver -#
    chmod 777 viewserver
fi

# Install Server Script
if [ ! -f installserver ]; then
    echo -e "$YELLOW Install Script $RESET"
    curl https://raw.githubusercontent.com/Zendrex/ARK-Linux-Server-Script/$Branch/.serverscript/installserver -o installserver -#
    chmod 777 installserver
fi

# Update Server Script
if [ ! -f updateserver ]; then
    echo -e "$YELLOW Update Script $RESET"
    curl https://raw.githubusercontent.com/Zendrex/ARK-Linux-Server-Script/$Branch/.serverscript/updateserver -o updateserver -#
    chmod 777 updateserver
fi

# Backup Server Script
if [ ! -f backupserver ]; then
    echo -e "$YELLOW Backup Script $RESET"
    curl https://raw.githubusercontent.com/Zendrex/ARK-Linux-Server-Script/$Branch/.serverscript/backupserver -o backupserver -#
    chmod 777 backupserver
fi

# Server Status Script
if [ ! -f serverstatus ]; then
    echo -e "$YELLOW Server Status Script $RESET"
    curl https://raw.githubusercontent.com/Zendrex/ARK-Linux-Server-Script/$Branch/.serverscript/serverstatus -o serverstatus -#
    chmod 777 serverstatus
fi

# Parameter Script
if [ ! -f parameters_check ]; then
    echo -e "$YELLOW Parameter Script $RESET"
    curl https://raw.githubusercontent.com/Zendrex/ARK-Linux-Server-Script/$Branch/.serverscript/parameters_check -o parameters_check -#
    chmod 777 parameters_check
fi

# Push File Script
if [ ! -f pushFile ]; then
    echo -e "$YELLOW Parameter Script $RESET"
    curl https://raw.githubusercontent.com/Zendrex/ARK-Linux-Server-Script/$Branch/.serverscript/pushFile -o pushFile -#
    chmod 777 pushFile
fi

# Changelog Script
if [ ! -f changelog ]; then
    echo -e "$YELLOW Changelog Script $RESET"
    curl https://raw.githubusercontent.com/Zendrex/ARK-Linux-Server-Script/$Branch/.serverscript/changelog -o changelog -#
    chmod 777 changelog
fi

if [[ $InfoNotify =~ true ]]; then
    echo -e " All scripts found."
    echo -e; sleep 0.5s
fi


####################################[ CHECK FOR OLD FILES ]#####################################

# Update Check Script
if [ -f update_check ]; then
    echo -e "$RED Old Files Found, Remove Them $RESET"
fi

cd ../
#####################################[ SERVER SCRIPT SCAN ]#####################################

# Check Script Version
if [[ $ScriptUpdater =~ true ]]; then
    updateFound="false"
    if [ -f version.ini ]; then
        rm version.ini
    fi
    echo -e "$YELLOW Checking for script updates. $RESET"
    curl -s https://raw.githubusercontent.com/Zendrex/ARK-Linux-Server-Script/$Branch/version.ini -o version.ini -#
    source version.ini
    
    # Main Shell Script
    if [ $arkserver_Current != $arkserver ]; then
        echo -e; echo -e "$YELLOW Main Script $RESET"
        curl https://raw.githubusercontent.com/Zendrex/ARK-Linux-Server-Script/$Branch/arkserver.sh -o arkserver.sh -#
        updateFound="true"
    fi
    cd .serverscript
    # Script Functions Script
    source _functions
    if [ $functionVer_Current != $functions ]; then
        echo -e; echo -e "$YELLOW Functions Script $RESET"
        curl https://raw.githubusercontent.com/Zendrex/ARK-Linux-Server-Script/$Branch/.serverscript/_functions -o _functions -#
        updateFound="true"
    fi
    # Parameters Check
    source parameters_check
    if [ $parameters_Current != $parameters ]; then
        echo -e; echo -e "$YELLOW Parameters Check Script $RESET"
        curl https://raw.githubusercontent.com/Zendrex/ARK-Linux-Server-Script/$Branch/.serverscript/parameters_check -o parameters_check -#
        updateFound="true"
    fi
    # Backup Server Script
    source backupserver
    if [ $backupserver_Current != $backupserver ]; then
        echo -e; echo -e "$YELLOW Backup Script $RESET"
        curl https://raw.githubusercontent.com/Zendrex/ARK-Linux-Server-Script/$Branch/.serverscript/backupserver -o backupserver -#
        updateFound="true"
    fi
    # Install Server Script
    source installserver
    if [ $installserver_Current != $installserver ]; then
        echo -e; echo -e "$YELLOW Install Script $RESET"
        curl https://raw.githubusercontent.com/Zendrex/ARK-Linux-Server-Script/$Branch/.serverscript/installserver -o installserver -#
        updateFound="true"
    fi
    # Server Status Script
    source serverstatus
    if [ $serverstatus_Current != $serverstatus ]; then
        echo -e; echo -e "$YELLOW Status Script $RESET"
        curl https://raw.githubusercontent.com/Zendrex/ARK-Linux-Server-Script/$Branch/.serverscript/serverstatus -o serverstatus -#
        updateFound="true"
    fi
    # Server Start Script
    source startserver
    if [ $startserver_Current != $startserver ]; then
        echo -e; echo -e "$YELLOW Start Script $RESET"
        curl https://raw.githubusercontent.com/Zendrex/ARK-Linux-Server-Script/$Branch/.serverscript/startserver -o startserver -#
        updateFound="true"
    fi
    # Server Stop Script
    source stopserver
    if [ $stopserver_Current != $stopserver ]; then
        echo -e; echo -e "$YELLOW Stop Script $RESET"
        curl https://raw.githubusercontent.com/Zendrex/ARK-Linux-Server-Script/$Branch/.serverscript/stopserver -o stopserver -#
        updateFound="true"
    fi
    # Server Updater Script
    source updateserver
    if [ $updateserver_Current != $updateserver ]; then
        echo -e; echo -e "$YELLOW Server Updater Script $RESET"
        curl https://raw.githubusercontent.com/Zendrex/ARK-Linux-Server-Script/$Branch/.serverscript/updateserver -o updateserver -#
        updateFound="true"
    fi
    # Server Viewer Script
    source viewserver
    if [ $viewserver_Current != $viewserver ]; then
        echo -e; echo -e "$YELLOW View Server Script $RESET"
        curl https://raw.githubusercontent.com/Zendrex/ARK-Linux-Server-Script/$Branch/.serverscript/viewserver -o viewserver -#
        updateFound="true"
    fi
    # Push File Script
    source pushFile
    if [ $pushFile_Current != $pushfile ]; then
        echo -e; echo -e "$YELLOW Push File Script $RESET"
        curl https://raw.githubusercontent.com/Zendrex/ARK-Linux-Server-Script/$Branch/.serverscript/pushFile -o pushFile -#
        updateFound="true"
    fi
    # Changelog Script
    source changelog
    if [ $changelog_Current != $changelog ]; then
        echo -e; echo -e "$YELLOW Changelog Script $RESET"
        curl https://raw.githubusercontent.com/Zendrex/ARK-Linux-Server-Script/$Branch/.serverscript/changelog -o changelog -#
        updateFound="true"
    fi
    
    if [[ $updateFound =~ true ]]; then
        echo -e; echo -e "$GREEN Script Update installed. Please restart the script. $RESET"
        exit 0
    fi
    
    cd ../
    # Config Version Checker
    #source configuration.ini
    if [ $ConfigVersion != $liveConfig ]; then
        echo -e "$ERR You have an outdated configuration file!"
        echo -e "$YELLOW There is a config update! Any config updates are important to the script. $RESET"
        echo -e "$YELLOW The script will make a backup of your current config. However you will have to $RESET"
        echo -e "$YELLOW edit the config file again. Sorry for the flaw in this design of the script. $RESET"
        sleep 1s
        echo -e; mv configuration.ini configuration_backup.ini
        echo -e "$YELLOW File backed up. Downloading new config file. $RESET"
        curl https://raw.githubusercontent.com/Zendrex/ARK-Linux-Server-Script/$Branch/configuration.ini -o configuration.ini -#
        echo -e; echo -e "$GREEN Configuration file updated. Please edit your config once again then restart the script. $RESET"
        echo -e "$GREEN Most options you can simply copy and paste as most config updates are additions or formatting. $RESET"
        echo -e; exit 0
    fi
    
    echo -e " All scripts up to date!"
    rm version.ini
else
    echo -e "$RED Script Update Checker Disabled $RESET"
    
    cd .serverscript
    source _functions
    source parameters_check
    source backupserver
    source installserver
    source serverstatus
    source startserver
    source stopserver
    source updateserver
    source viewserver
    source pushFile
    source changelog
    cd ../
    #source configuration.ini
fi

cd .serverscript
# Commands
help () {
    echo -e; echo -e "$WHITE Use the following commands: $RESET"
    echo -e; echo -e "$CYAN ./arkserver.sh <start|stop|view|status|install|update|updatecheck|backup|pushFile|changelog> $RESET"
    echo -e; echo -e
}

start () {
    clear
    startServer
}

stop () {
    clear
    stopServer
}

view () {
    clear
    viewServer
}

install () {
    clear
    installServer
}

update () {
    clear
    updateServer
}

updatecheck () {
    clear
    updateCheck
}

backup () {
    clear
    backupServer
}

status () {
    clear
    serverStatus
}

pushFile () {
    clear
    pushFileSystem
}

changelog () {
    clear
    checkChangelog
}

versions () {
    clear
    readVersions
}

[ "$1" = "" ] && {
    help
    exit
}

$*
echo
exit 0
