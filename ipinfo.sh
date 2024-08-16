#!/bin/bash
# get info about IP
# written by Max Chudnovsky

# INIT
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
PRG=$(basename $0)

# If no alias created, lets create it so we can run utility by its name
if [ "$(alias | grep "$PRG")" == "" ]; then
    if [ "$(grep ipinfo.sh ~/.bashrc)" == "" ]; then
	echo "NOTICE: you are running utility first time.  Adding alias: ipinfo to your .bashrc file."
	echo 'alias ipinfo="'$SCRIPT_DIR/$PRG'"' >> ~/.bashrc
    fi
fi

getinfo(){
	# function pulls info about IP from ipinfo.io api
	curl http://ipinfo.io/$IP 2>&1 | awk -F\" '$2=="ip"{printf("%s:",$4)}$2=="org"{printf("%s",$4)}END{print ""}'
}

# lets check if parameter is IP and get ip if its not
if [[ "$1" =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
	IP=$1
else
	# api will return your external ip info if no IP provided which is also info
	# we will only query for hostname if parameter was provided
	[ "$1" != "" ] && IP=$(host $1 | awk 'NR==1{print $NF}') 
fi

# main
getinfo
