#!/bin/bash

#pull in settings file
source settings


#check that curl is present
CURL_LOC="$(which curl)"
if [ "$CURL_LOC" = "" ]; then
	echo "Curl not found.  Please install sudo apt-get install curl etc..."
	exit
fi

MANTL_MESOS="$MANTL_PREFIX://$MANTL_SERVER:$MANTL_SERVER_PORT/"



if [ -e ".token" ]; then
        USER_AM_TOKEN=$(cat .token | cut -d "\"" -f 2) #remove start and end quotes
else
        echo "Token not found in .token file.  Use ./get_tokenid.sh to create"
fi
        echo ""


curl -k -X GET  --cookie "amlbcookie=01; iPlanetDirectoryPro=$USER_AM_TOKEN"  -H "Content-type: application/json" $MANTL_MARATON

